namespace :challenge do
  desc 'send book challenge mail'
  task book: :environment do
    published_users = User.where(published: true).order(:id)
    published_users.each do |user|
      begin
        puts "processing user_id #{user.id}, mail #{user.email}"
        Mailchimp.send_template(
          template_name: 'c-est-l-heure-bloomr-challenge-2',
          to_mail: user.email,
          from_mail: 'stephanie@bloomr.org',
          from_name: 'Stephanie de Bloomr',
          vars: { first_name: user.first_name },
          subject: "C'est l'heure de Bloomr ! Challenge #2"
        )
      rescue StandardError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end

  desc 'send 2 book challenge mail'
  task book_again: :environment do
    read_challenge = Challenge.find_by name: 'must read'
    published_users = User.includes(:challenges)
                          .where(published: true).order(:id)
    users_with_no_books = published_users
                          .reject { |u| u.challenges.include?(read_challenge) }
    users_with_no_books.each do |user|
      begin
        puts "processing user_id #{user.id}, mail #{user.email}"
        Mailchimp.send_template(
          template_name: 'challenge-2-livre-de-chevet-relance',
          to_mail: user.email,
          from_mail: 'stephanie@bloomr.org',
          from_name: 'Stephanie de Bloomr',
          vars: { first_name: user.first_name },
          subject: "C'est l'heure de Bloomr ! Challenge #2"
        )
      rescue StandardError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end
