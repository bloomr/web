class PaymentController < ApplicationController
  before_action :fetch_customer_campaign, only: [:index, :create]
  before_action :fetch_program_name, only: [:index, :create]
  before_action :fetch_gift_and_buyer_email, only: [:create]

  def index
    @price = @campaign.amount_to_display(@program_name)
  end

  def create
    bloomy = create_bloomy
    charge(bloomy)
    if @gift
      redirect_to(payment_thanks_path(gift: true))
    else
      redirect_to(payment_thanks_path(email: URI.encode(bloomy.email)))
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

  def create_bloomy
    bloomy = Bloomy.new(bloomy_params)
    bloomy.programs << Program.from_name(@program_name)
    bloomy.save!
    Intercom::Wrapper.create_bloomy(bloomy, @gift)
    bloomy
  end

  def fetch_customer_campaign
    @campaign = Campaign.find_by_partner_or_default(cookies[:partner])
  end

  def fetch_program_name
    @program_name = params[:program_name] || 'standard'
  end

  def fetch_gift_and_buyer_email
    @gift = !params[:gift].nil?
    @buyer_email = @gift ? params[:buyer_email] : bloomy_params[:email]
  end

  def bloomy_params
    params.require(:bloomy).permit(:email, :first_name, :age, :password, :name)
  end

  def charge(bloomy)
    payload = {
      amount: @campaign.amount(@program_name),
      currency: 'eur',
      source: params[:stripeToken],
      description: '1 Parcours Bloomr',
      receipt_email: @buyer_email,
      metadata: metadata(bloomy)
    }

    Stripe::Charge.create(payload)
  end

  def metadata(bloomy)
    bloomy_s = "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}"
    metadata = { 'info_client' => bloomy_s }
    metadata['source'] = @campaign.partner
    metadata['gift'] = @gift
    metadata
  end
end
