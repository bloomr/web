class PaymentController < ApplicationController
  def index
    render layout: 'home'
  end

  def create
    bloomie = params[:first_name] + ' - ' + params[:age] + ' ans - ' + params[:email]

    # Amount in cents
    if cookies[:sujetdubac]
      amount = 990
      metadata = { 'info_client' => bloomie, 'source' => 'sujetdubac' }
    else
      amount = 3500
      metadata = { 'info_client' => bloomie }
    end

    token = params[:stripeToken]

    Stripe::Charge.create(
      amount: amount,
      currency: 'eur',
      source: token,
      description: '1 Parcours Bloomr',
      receipt_email: params[:email],
      metadata: metadata
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
