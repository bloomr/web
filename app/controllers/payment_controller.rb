class PaymentController < ApplicationController
  def index
    render layout: 'home'
  end

  def create
    # Amount in cents
    @amount = 3500

    token = params[:stripeToken]
    bloomie = params[:first_name] + ' - ' + params[:age] + ' ans - ' + params[:email]

    charge = Stripe::Charge.create(
      :amount       => @amount,
      :metadata     => {'info_client' => bloomie}
      currency: 'eur',
      source: token,
      description: '1 Parcours Bloomr',
      receipt_email: params[:email],
    )

    redirect_to payment_thanks_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payment_index_path
  end

  def thanks
    render layout: 'home'
  end
end
