module MailchimpMails
  class Mission2
    # rubocop:disable MethodLength
    def self.template(bloomy, password)
      {
        template_name: 'mission-2-rejoindre-la-communaute',
        to_mail: bloomy.email,
        from_name: 'Le programme Bloomr',
        from_mail: 'hello@bloomr.org',
        subject: '[Mail 2 - Etape 1] Mission #2 : Dis nous qui tu es',
        vars: {
          first_name: bloomy.first_name.capitalize,
          email: bloomy.email,
          password: password }
      }
    end
  end
end
