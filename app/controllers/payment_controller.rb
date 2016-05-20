class PaymentController < ApplicationController
  def index
    render layout: 'home'
  end

  def create
    password = generate_weak_password
    bloomy = Bloomy.create!(bloomy_params.merge(password: password))
    charge(bloomy)
    subscribe_to_mails(bloomy, password)
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

  def subscribe_to_mails(bloomy, password)
    if cookies[:auto]
      Mailchimp.subscribe_to_journey(bloomy)
      Mailchimp.send_discourse_email(to_mail: bloomy.email,
                                     password: password)
    end
  end

  def generate_weak_password
    'la ' +
      %w( fraise framboise pêche poire pomme
          banane mangue cerise tomate myrtille ).sample + ' ' +

      %w( délicieuse incroyable fantastique merveilleuse
          rouge jaune verte bleue orange mauve ).sample
  end
end
