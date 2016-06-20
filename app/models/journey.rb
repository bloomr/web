class Journey
  def initialize(bloomy, password)
    Mailchimp.subscribe_to_journey(bloomy)
    Mailchimp.send_presentation_email(bloomy)
    Mailchimp.send_rejoindre_communaute_email(bloomy, password)
  end
end
