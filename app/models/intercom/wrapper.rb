module Intercom
  class Wrapper
    include Singleton

    def intercom
      @intercom ||= Intercom::Client.new(token: ENV['INTERCOM_PAT'])
    end

    def create_or_update_user(user)
      h = {
        email: user.email,
        name: user.first_name,
        signed_up_at: user.created_at.to_i,
        last_request_at: user.last_sign_in_at.to_i,
        user_id: user.id,
        last_seen_ip: user.current_sign_in_ip,
        custom_attributes: {
          published: user.published,
          profile: "https://www.bloomr.org/portraits/#{user.id}"
        }
      }

      unless user.avatar_file_name.blank?
        h[:avatar] = { type: 'avatar', 'image_url': user.avatar.url('thumb') }
      end

      intercom.users.create(h)
    end
    handle_asynchronously :create_or_update_user

    def user_complete_challenge(challenges_user)
      title = challenges_user.challenge.name.gsub(' ', '-')

      intercom.events.create(
        event_name: "completed-#{title}-challenge",
        created_at: challenges_user.created_at.to_i,
        user_id: challenges_user.user_id
      )
    end
    handle_asynchronously :user_complete_challenge
  end
end
