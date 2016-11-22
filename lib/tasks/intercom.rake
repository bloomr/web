namespace :intercom do
  def create_intercom
    Intercom::Client.new(token: ENV['INTERCOM_PAT'])
  end

  def sync_users
    intercom = create_intercom
    User.all.each_with_index do |u, i|
      puts "working for user #{i} : #{u.email}"
      begin
        h = {
          email: u.email,
          name: u.first_name,
          signed_up_at: u.created_at.to_i,
          last_request_at: u.last_sign_in_at.to_i,
          user_id: u.id,
          last_seen_ip: u.current_sign_in_ip,
          avatar: { type: 'avatar', 'image_url': u.avatar.url('thumb') },
          custom_attributes: { published: u.published, profile: "https://www.bloomr.org/portraits/#{u.id}" }
        }

        intercom.users.create(h)
      rescue StandardError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end

  def sync_challenges_events
    intercom = create_intercom
    ChallengesUser.all.each_with_index do |challenges_user, i|
      puts "challengesUser #{i}"
      title = case challenges_user.challenge_id
              when 1
                'the-tribes'
              when 2
                'must-read'
              when 3
                'interview'
              end

      intercom.events.create(
        event_name: "completed-#{title}-challenge",
        created_at: challenges_user.created_at.to_i,
        user_id: challenges_user.user_id
      )
    end
  end

  desc 'sync db with intercom'
  task sync: :environment do
    sync_users
    sync_challenges_events
  end
end
