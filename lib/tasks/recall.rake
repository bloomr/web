namespace :recall do

  def recall user
    puts "working for user_id #{user.id}, mail #{user.email}"
    password = generate_weak_password
    user.password = password
    user.save
    UserRecallMailer.recall_email(user, password).deliver_now
  end

  def generate_weak_password
    'la ' +
    %w( fraise framboise pêche poire pomme banane mangue cerise tomate myrtille ).sample + ' '  +
    %w( délicieuse incroyable fantastique merveilleuse rouge jaune verte bleue orange mauve ).sample
  end

	desc 'reset password and send email'
  task users: :environment do
    if ENV['EMAILS'].nil?
      puts 'usage EMAIL="loulou@lou.com, lola@lol.com" rake recall:user'
      return
    end
    emails = ENV['EMAILS'].split
    emails.each{ |email| recall(User.find_by(email: email)) }
  end

	desc 'reset password and send email to all ! DANGEROUS'
  task all_users: :environment do
    User.all.each do |user|
      next if user.email.nil? || user.published == false
      begin
        recall(user)
      rescue Exception => e
         puts e.message
         puts e.backtrace.inspect
      end
    end
  end
end
