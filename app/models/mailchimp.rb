require 'mandrill'

class Mailchimp
  JOURNEY_URL = 'https://us9.api.mailchimp.com/3.0/lists/9ec70e12ca/members'
                .freeze

  def self.subscribe_to_journey(bloomy)
    return if ENV['MAILCHIMP_ACTIVATED'].nil?

    body = { 'status' => 'subscribed', 'email_address' => bloomy.email,
             'merge_fields' =>
    { 'FNAME' => bloomy.first_name, 'MMERGE3' => bloomy.age }
    }.to_json

    HTTParty.post(JOURNEY_URL, headers: headers, body: body)
  end

  def self.headers
    { 'Authorization' => "apikey #{ENV['MAILCHIMP_API_KEY']}",
      'Content-Type'  => 'application/json' }
  end

  def self.send_discourse_email(to_mail:, password:)
    send_template(template_name: 'mail parcours relance', to_mail: to_mail,
                  from_name: 'Noemie', from_mail: 'noemie@bloomr.org',
                  subject: 'Accès à Discouse', vars: { password: password })
  end

  # rubocop:disable MethodLength, ParameterLists
  def self.send_template(template_name:, to_mail:, from_name:,
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
