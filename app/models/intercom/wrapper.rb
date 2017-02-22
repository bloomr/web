module Intercom
  class Wrapper
    class << self
      def intercom
        @intercom ||= Intercom::Client.new(token: ENV['INTERCOM_PAT'])
      end

      def create_bloomy(bloomy, gift)
        h = {
          email: bloomy.email,
          name: bloomy.first_name,
          signed_up_at: Time.now.to_i,
          last_request_at: Time.now.to_i,
          last_seen_ip: bloomy.current_sign_in_ip,
          custom_attributes: {
            age: bloomy.age,
            bloomy: true,
            programName: bloomy.programs.first.name,
            gift: gift
          }
        }
        intercom.users.create(h)
      end
      handle_asynchronously :create_bloomy

      def create_or_update_user(user)
        h = {
          email: user.email,
          name: user.first_name,
          signed_up_at: user.created_at.to_i,
          last_request_at: user.current_sign_in_at.to_i,
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

      def user_complete_challenge(challenge_name, created_at, user_id)
        title = challenge_name.gsub(' ', '-')

        intercom.events.create(
          event_name: "completed-#{title}-challenge",
          created_at: created_at,
          user_id: user_id
        )
      end
      handle_asynchronously :user_complete_challenge
    end
  end
end
