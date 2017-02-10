class PaymentController < ApplicationController
  before_action :fetch_customer_campaign, only: [:index, :create]
  before_action :fetch_gift_and_buyer_email, only: [:create]

  def index
    @price = price_to_display
  end

  def create
    bloomy = Bloomy.new(bloomy_params)
    bloomy.programs << Program.standard
    bloomy.save!
    charge(bloomy)
    if @gift
      redirect_to(payment_thanks_path(gift: true))
    else
      redirect_to(payment_thanks_path)
    end

  rescue StandardError => e
    flash[:error] = e.message
    redirect_to payment_index_path
  end

  def thanks
  end

  def voucher
    send_file("#{Rails.root}/public/voucher.pdf", filename: 'coupon_bloomr.pdf')
  end

  private

  def fetch_customer_campaign
    @campaign = Campaign.find_by_partner_or_default(cookies[:partner])
  end

  def fetch_gift_and_buyer_email
    @gift = !params[:gift].nil?
    @buyer_email = @gift ? params[:buyer_email] : bloomy_params[:email]
  end

  def bloomy_params
    params.require(:bloomy).permit(:email, :first_name, :age, :password)
  end

  def charge(bloomy)
    payload = {
      amount: amount,
      currency: 'eur',
      source: params[:stripeToken],
      description: '1 Parcours Bloomr',
      receipt_email: @buyer_email,
      metadata: metadata(bloomy)
    }

    Stripe::Charge.create(payload)
  end

  def amount
    @campaign.price.to_i * 100
  end

  def metadata(bloomy)
    bloomy_s = "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}"
    metadata = { 'info_client' => bloomy_s }
    metadata['source'] = @campaign.partner
    metadata['gift'] = @gift
    metadata
  end

  def price_to_display
    format('%0.02f', amount.to_f / 100)
  end
end
