class PaymentController < ApplicationController
  before_action :fetch_customer_campaign, only: [:index, :create]

  def index
    @price = price_to_display
  end

  def create
    password = WeakPassword.instance
    bloomy = Bloomy.create!(bloomy_params.merge(password: password))
    charge(bloomy)
    Journey.new(bloomy, password)
    redirect_to payment_thanks_path

  rescue StandardError => e
    flash[:error] = e.message
    redirect_to payment_index_path
  end

  def thanks
  end

  private

  def fetch_customer_campaign
    @campaign = Campaign.find_by_partner_or_default(cookies[:partner])
  end

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
    @campaign.price.to_i * 100
  end

  def metadata(bloomy)
    bloomy_s = "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}"
    metadata = { 'info_client' => bloomy_s }
    metadata['source'] = @campaign.partner
    metadata
  end

  def price_to_display
    format('%0.02f', amount.to_f / 100)
  end
end
