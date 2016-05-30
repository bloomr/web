module MailchimpMails
  class NotifNewBloomer
    # rubocop:disable MethodLength
    def self.template(email, first_name, job_title)
      {
        from: 'alfred@bloomr.org',
        to: 'contact@bloomr.org',
        subject: "Nouveau bloomeur: #{first_name}",
        body: <<-EOF
Un nouveau bloomeur vient de se déclarer !
email: #{email}
nom: #{first_name},
metier: #{job_title}
        EOF
      }
    end
  end
end
