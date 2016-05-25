require 'mandrill'
require 'csv'

namespace :discourse do
  def generate_weak_password
    'la ' +
      %w( fraise framboise pêche poire pomme
          banane mangue cerise tomate myrtille ).sample + ' ' +
      %w( délicieuse incroyable fantastique merveilleuse
          rouge jaune verte bleue orange mauve ).sample
  end

  def generate_bloomy(line)
    password = generate_weak_password
    bloomy = Bloomy.create!(
      email: line['email'],
      first_name: line['first_name'].nil? ? nil : line['first_name'].capitalize,
      age: line[:age],
      password: password)
    [bloomy, password]
  end

  desc 'send mail to finishers'
  task finishers: :environment do
    csv = CSV.read('./test.csv',
                   col_sep: "\t", headers: true)
    # csv = CSV.read('./finishers.csv',
    #                encoding: 'UTF-16:UTF-8', col_sep: "\t", headers: true)
    count = csv.count
    csv.each do |l, i|
      begin
        puts "#{i + 1}/#{count} #{l['email']}"
        bloomy, password = generate_bloomy(l)
        Mailchimp.send_template(
          template_name: 'mail-discourse-pour-les-anciens-inscrits',
          to_mail: bloomy.email,
          from_name: 'Le parcours Bloomr',
          from_mail: 'hello@bloomr.org',
          subject: 'On lance le forum Bloomr ! Rejoins-nous.',
          vars: {
            first_name: bloomy.first_name,
            email: bloomy.email,
            password: password })

      rescue Exception => e
        puts e.message
        puts l
      end
    end
  end

  desc 'send mail to current users'
  task current: :environment do
    csv = CSV.read('./test.csv',
                   col_sep: "\t", headers: true)
    # csv = CSV.read('./current.csv',
    #                encoding: 'UTF-16:UTF-8', col_sep: "\t", headers: true)
    count = csv.count
    csv.each_with_index do |l, i|
      begin
        puts "#{i + 1}/#{count} #{l['email']}"
        bloomy, password = generate_bloomy(l)

        Mailchimp.send_template(
          template_name: 'mail-discourse-pour-les-inscrits-en-cours',
          to_mail: bloomy.email,
          from_name: 'Le parcours Bloomr',
          from_mail: 'hello@bloomr.org',
          subject:
          '[Mission extraordinaire] Rejoins-nous sur le nouveau forum Bloomr ',
          vars: {
            first_name: bloomy.first_name,
            email: bloomy.email,
            password: password
          })
      rescue Exception => e
        puts e.message
        puts l
      end
    end
  end

end
