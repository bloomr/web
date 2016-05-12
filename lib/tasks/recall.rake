require 'mandrill'

namespace :recall do
  def recall(user)
    puts "working for user_id #{user.id}, mail #{user.email}"
    password = generate_weak_password
    user.password = password
    user.save
    UserRecallMailer.recall_email(user, password).deliver_now
  end

  def generate_weak_password
    'la ' +
      %w( fraise framboise pêche poire pomme banane mangue cerise tomate myrtille ).sample + ' ' +
      %w( délicieuse incroyable fantastique merveilleuse rouge jaune verte bleue orange mauve ).sample
  end

  # template_name
  # to_mail
  # from_name
  # from_mail
  # vars = { name: 'sim', password: 'secret' }
  def send_template(options)
    vars = options[:vars].inject([]) do |acc, couple|
      acc.push('name' => couple[0].to_s, 'content' => couple[1])
    end

    begin
      mandrill = Mandrill::API.new(ENV['SMTP_PASSWORD'])
      template_name = options[:template_name]
      message = {
        'merge_vars' =>
           [{
             'rcpt' => options[:to_mail],
             'vars' => vars
           }],
        'merge_language' => 'mailchimp',
        'merge' => true,
        'headers' => { 'Reply-To' => options[:from_mail] },
        'to' =>
          [{ 'type' => 'to',
             'email' => options[:to_mail]
          }],
        'from_name' => options[:from_name],
        'subject' => options[:subject],
        'from_email' => options[:from_mail]
      }
      async = false
      ip_pool = 'Main Pool'
      mandrill.messages.send_template template_name, nil, message, async, ip_pool, nil

    rescue Mandrill::Error => e
      puts "A mandrill error occurred: #{e.class} - #{e.message}"
      raise
    end
  end

  def send_template_recall(to_mail:, name:, password:)
    send_template template_name: 'mail parcours relance', to_mail: to_mail,
                  from_mail: 'stephanie@bloomr.org', from_name: 'Stephanie de Bloomr',
                  subject: 'On vous l’avait promis, Bloomr grandit !',
                  vars: { name: name, password: password }
  end

  def second_recall(user)
    puts "working for user_id #{user.id}, mail #{user.email}"
    password = generate_weak_password
    user.password = password
    user.save
    send_template_recall to_mail: user.email, name: user.first_name, password: password
  end

  desc 'send a second recall for people not responding to the first'
  task second_recall: :environment do
    published_before = User.where(published: true).where(['created_at < ?', Date.new(2016, 04, 24)])
    users_no_challenges = published_before.select { |u| u.challenges.count == 0 }
    users_no_challenges.each do |u|
      begin
        second_recall(u)
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end

  desc 'reset password and send email'
  task users: :environment do
    if ENV['EMAILS'].nil?
      puts 'usage EMAIL="loulou@lou.com, lola@lol.com" rake recall:user'
      return
    end
    emails = ENV['EMAILS'].split
    emails.each { |email| recall(User.find_by(email: email)) }
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
