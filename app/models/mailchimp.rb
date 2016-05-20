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
end
