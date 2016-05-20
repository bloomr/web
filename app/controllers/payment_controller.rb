class PaymentController < ApplicationController
  def index
    render layout: 'home'
  end

  def create
    bloomy = Bloomy.create!(bloomy_params.merge(password: 'totototo'))
    charge(bloomy)
    Mailchimp.subscribe_to_journey(bloomy)
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
end
