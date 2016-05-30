module MailchimpMails
  class Mission1
    # rubocop:disable MethodLength
    def self.template(bloomy, password)
      {
        template_name: 'premier-mail-du-parcours',
        to_mail: bloomy.email,
        from_name: 'Le parcours Bloomr',
        from_mail: 'hello@bloomr.org',
        subject: '[Mail 1 - Etape 1] Mission #1 : Dis nous qui tu es',
        vars: {
          first_name: bloomy.first_name.capitalize,
          email: bloomy.email,
          password: password }
      }
    end
  end
end
