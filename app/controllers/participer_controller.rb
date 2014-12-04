class ParticiperController < ApplicationController

  def index
    @user = User.new(:email => params[:email], :job_title => params[:metier])
  end

  def create
    generated_password = Devise.friendly_token.first(8)
    registration_params[:password] = generated_password
    # TODO Faire en sorte que la ligne du dessous accepte ce f%$°&ing password. Je déteste Rails btw.
    @user = User.new(registration_params)
    if @user.save
      redirect_to root_path
      # TODO Rediriger vers une page de remerciement ou qqc comme ça
    else
      render 'participer/index'
      # TODO Afficher les erreurs éventuelles dans le formulaire (surtout pour l'email)
    end
  end

  def registration_params
    # TODO J'arrive pas à faire accepter le champ "questions"
    params.require(:registration).permit(:email, :job_title, :first_name, :questions)
  end

end
