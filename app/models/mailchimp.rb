require 'mandrill'

class Mailchimp
  class << self
    def subscribe_to_journey(bloomy)
      body = { 'status' => 'subscribed', 'email_address' => bloomy.email,
               'merge_fields' =>
      { 'FNAME' => bloomy.first_name, 'MMERGE3' => bloomy.age }
      }.to_json

      HTTParty.post(JOURNEY_URL, headers: headers, body: body)
    end

    def send_notif_about_bloomeur(email, first_name, job_title)
      ActionMailer::Base.mail(
        MailchimpMails::NotifNewBloomer.template(email, first_name, job_title))
                        .deliver_later
    end

    def send_premier_parcours_email(bloomy, password)
      send_template(MailchimpMails::Mission1.template(bloomy, password))
    end
    handle_asynchronously :send_premier_parcours_email,
                          run_at: proc { 1.hour.from_now }

    def send_presentation_email(bloomy)
      send_template(MailchimpMails::Presentation.template(bloomy))
    end

    JOURNEY_URL = 'https://us9.api.mailchimp.com/3.0/lists/e6faea0c3a/members'
                  .freeze

    def headers
      { 'Authorization' => "apikey #{ENV['MAILCHIMP_API_KEY']}",
        'Content-Type'  => 'application/json' }
    end

    # rubocop:disable MethodLength, ParameterLists
    def send_template(template_name:, to_mail:, from_name:,
                      from_mail:, subject:, vars:)

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
          'from_name' => from_name, 'subject' => subject,
          'from_email' => from_mail
        }
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
