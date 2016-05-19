class PaymentController < ApplicationController
  def index
    render layout: 'home'
  end

  def create
    bloomy = Bloomy.create!(bloomy_params.merge(password: 'totototo'))
    charge(bloomy)
    subscribe_to_mailchimp(bloomy)
    redirect_to payment_thanks_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_index_path
  end

  def thanks
    render layout: 'home'
  end

  private

  def bloomy_params
    params.require(:bloomy).permit(:email, :first_name, :age)
  end

  def charge(bloomy)
    Stripe::Charge.create(
      amount: amount,
      currency: 'eur',
      source: params[:stripeToken],
      description: '1 Parcours Bloomr',
      receipt_email: bloomy.email,
      metadata: metadata(bloomy)
    )
  end

  def amount
    return 990 if cookies[:sujetdubac]
    3500
  end

  def metadata(bloomy)
    bloomy_s = "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}"
    metadata = { 'info_client' => bloomy_s }
    metadata['source'] = 'sujetdubac' if cookies[:sujetdubac]
    metadata
  end

  def subscribe_to_mailchimp(bloomy)
    return if ENV['MAILCHIMP_ACTIVATED'].nil?

    headers = { 'Authorization' => "apikey #{ENV['MAILCHIMP_API_KEY']}",
                'Content-Type'  => 'application/json' }

    body = { 'status' => 'subscribed', 'email_address' => bloomy.email,
             'merge_fields' =>
             { 'FNAME' => bloomy.first_name, 'MMERGE3' => bloomy.age }
           }.to_json

    url = 'https://us9.api.mailchimp.com/3.0/lists/9ec70e12ca/members'

    HTTParty.post(url, headers: headers, body: body)
  end
end
