module MailchimpMails
  class Presentation
    def self.template(bloomy)
      {
        template_name: 'presentation-du-parcours',
        to_mail: bloomy.email,
        from_name: 'Vi & No de Bloomr',
        from_mail: 'hello@bloomr.org',
        subject: 'Bienvenue !',
        vars: {
          first_name: bloomy.first_name.capitalize
        }
      }
    end
  end
end
