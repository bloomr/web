class PaymentController < ApplicationController

  def index
    render layout: 'home'
  end

  def create
    # Amount in cents
    @amount = 1500

    token = params[:stripeToken]
    bloomie = params[:email] + '-' + params[:first_name] + '-' + params[:age]

    charge = Stripe::Charge.create(
      :amount       => @amount,
      :currency     => 'eur',
      :source       => token, #visiblement si je le supprime le test rspec passe quand même !!
      :description  => bloomie
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
