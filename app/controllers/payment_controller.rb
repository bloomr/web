class PaymentController < ApplicationController
  def index
    @price = sprintf("%0.02f", amount.to_f/100)
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
    if Campaign.exists?
      for campaign in Campaign.all
        #On prend le premier qu'on trouve. Question : si plusieurs cookies, est-on sûr que cela sera le même montant
        #qui sera retourné à l'affichage du formulaire et au paiement ?!
        if cookies[campaign.partner] then return campaign.price*100 end
      end
    end
    3500

  end

  def metadata(bloomy)
    bloomy_s = "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}"
    metadata = { 'info_client' => bloomy_s }
    if Campaign.exists?
      for campaign in Campaign.all
        if cookies[campaign.partner] then metadata['source'] = campaign.partner end
      end
    end
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
