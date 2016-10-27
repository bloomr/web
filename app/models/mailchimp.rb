require 'mandrill'

class Mailchimp
  class << self
    def subscribe_to_journey(bloomy)
      body = { 'status' => 'subscribed', 'email_address' => bloomy.email,
               'merge_fields' => { 'FNAME' => bloomy.first_name } }
      body['merge_fields']['AGE'] = bloomy.age if bloomy.age
      response = HTTParty.post(JOURNEY_URL, headers: headers, body: body.to_json)
      raise "Mailchimp Error: #{response}" unless response.success?
    end

    def send_notif_about_bloomeur(email, first_name, job_title)
      return if ENV['DISABLE_MAILS']

      ActionMailer::Base.mail(
        MailchimpMails::NotifNewBloomer.template(email, first_name, job_title))
                        .deliver_later
    end

    def send_rejoindre_communaute_email(bloomy, password)
      send_template(MailchimpMails::Mission2.template(bloomy, password))
    end
    handle_asynchronously :send_rejoindre_communaute_email,
                          run_at: proc { 2.hour.from_now }

    def send_presentation_email(bloomy)
      send_template(MailchimpMails::Presentation.template(bloomy))
    end

    JOURNEY_URL = 'https://us9.api.mailchimp.com/3.0/lists/58fadd9d86/members'
                  .freeze

    def headers
      { 'Authorization' => "apikey #{ENV['MAILCHIMP_API_KEY']}",
        'Content-Type'  => 'application/json' }
    end

    # rubocop:disable MethodLength, ParameterLists
    def send_template(template_name:, to_mail:, from_name:,
                      from_mail:, subject: '', vars:)

      if ENV['DISABLE_MAILS']
        puts 'sending mail is desactivated by conf'
        return
      end

      vars = vars.inject([]) do |acc, couple|
        acc.push('name' => couple[0].to_s, 'content' => couple[1])
      end

      begin
        mandrill = Mandrill::API.new(ENV['SMTP_PASSWORD'])
        template_name = template_name
        message = {
          'merge_vars' => [{ 'rcpt' => to_mail, 'vars' => vars }],
          'merge_language' => 'mailchimp', 'merge' => true,
          'headers' => { 'Reply-To' => from_mail },
          'to' => [{ 'type' => 'to', 'email' => to_mail }],
          'from_name' => from_name,
          'from_email' => from_mail
        }

        message['subject'] = subject unless subject.blank?

        async = false
        ip_pool = 'Main Pool'
        mandrill.messages.send_template(template_name, nil, message,
                                        async, ip_pool, nil)

      rescue Mandrill::Error => e
        puts "A mandrill error occurred: #{e.class} - #{e.message}"
        raise
      end
    end
  end
end
