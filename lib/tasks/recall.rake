namespace :recall do

  def recall user
    puts "working for user_id #{user.id}"
    password = generate_weak_password
    user.password = password
    user.save
    UserRecallMailer.recall_email(user, password).deliver_now
  end

  def generate_weak_password
    ['la fraise', 'la framboise', 'la pêche', 'la poire', 'la pomme', 'la banane'].sample + ' ' +
    ['délicieuse', 'incroyable', 'fantastique', 'merveilleuse'].sample + ' et ' +
    ['jaune', 'rouge', 'verte', 'bleue', 'rayée'].sample
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
end
