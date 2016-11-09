class Journey
  def initialize(bloomy, password, bred: false)
    Mailchimp.subscribe_to_journey(bloomy, bred: bred)
    Mailchimp.send_presentation_email(bloomy)
    Mailchimp.send_rejoindre_communaute_email(bloomy, password)
  end
end
