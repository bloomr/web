class PaymentController < ApplicationController
  before_action :redirect_to_email_if_unknown, only: [:card, :charge]
  before_action :redirect_to_email_if_already_have_program, only: [:card, :charge]

  def index
    @program_name = program_name
  end

  def post_email
    email = params[:bloomy][:email]
    bloomy = Bloomy.find_by(email: email)

    if bloomy.nil?
      return redirect_to payment_identity_path(program_name: program_name, email: URI.encode(email))
    end

    if bloomy.programs.pluck(:name).include?(program_name)
      flash[:error] = flash_text_for_already_have_program(program_name)
      redirect_to payment_index_path(program_name: program_name)
    else
      redirect_to payment_card_path(program_name: program_name, bloomy_id: bloomy.id)
    end
  end

  def identity
    @bloomy = Bloomy.new(email: params[:email])
    @program_name = program_name
  end

  def create_bloomy
    # TODO: create or update dans le cas ou la personne est revenu en arriere ?
    bloomy = Bloomy.create!(bloomy_params)
    redirect_to payment_card_path(program_name: program_name, bloomy_id: bloomy.id)
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to payment_identity_path(program_name: program_name, email: bloomy_params[:email])
  end

  def card
    @bloomy_id = params[:bloomy_id]
    @program_name = program_name
    @price = campaign.amount_to_display(program_name)
  end

  def charge
    bloomy = Bloomy.find(params[:bloomy_id])
    stripe_charge(bloomy)
    bloomy.programs << ProgramTemplate.find_by(name: program_name).to_program

    Intercom::Wrapper.create_bloomy(bloomy, false)
    redirect_to(payment_thanks_path(email: URI.encode(bloomy.email)))
  rescue StandardError => e
    flash[:error] = e.message
    redirect_to payment_card_path(program_name: program_name, bloomy_id: bloomy.id)
  end

  def thanks
  end

  def voucher
    send_file("#{Rails.root}/public/voucher.pdf", filename: 'coupon_bloomr.pdf')
  end

  private

  def campaign
    Campaign.find_by_partner_or_default(cookies[:partner])
  end

  def program_name
    params[:program_name] || 'standard'
  end

  def bloomy_params
    params.require(:bloomy).permit(:email, :first_name, :age, :password, :name)
  end

  def stripe_charge(bloomy)
    payload = {
      amount: campaign.amount(program_name),
      currency: 'eur',
      source: params[:stripeToken],
      description: '1 Parcours Bloomr',
      receipt_email: bloomy.email,
      metadata: metadata(bloomy)
    }

    Stripe::Charge.create(payload)
  end

  def metadata(bloomy)
    bloomy_s = "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}"
    metadata = { 'info_client' => bloomy_s }
    metadata['source'] = campaign.partner
    metadata['program_name'] = program_name
    metadata
  end

  def redirect_to_email_if_unknown
    if Bloomy.find_by(id: params[:bloomy_id]).nil?
      flash[:error] = 'Désolé, on ne te trouve pas. Réinscris-toi !'
      redirect_to payment_index_path(program_name: program_name)
    end
  end

  def redirect_to_email_if_already_have_program
    if Bloomy.find(params[:bloomy_id]).programs.pluck(:name).include?(program_name)
      # TOTO: verifier avec l ui que ca marche
      flash[:error] = flash_text_for_already_have_program(program_name)
      redirect_to payment_index_path
    end
  end

  def flash_text_for_already_have_program(program_name)
    "Tu es déjà inscrit·e au programme #{program_name}.<br /> Retrouve la liste des programmes <a href='/programme'>en cliquant ici</a>"
  end
end
