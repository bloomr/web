class BloomySessionsController < ApplicationController
  respond_to :html, :json
  skip_before_action :verify_authenticity_token

  def create
    bloomy_email = params[:bloomy][:email].presence
    bloomy = bloomy_email && Bloomy.find_by(email: bloomy_email)

    if bloomy && bloomy.valid_password?(params[:bloomy][:password])
      # store: false to avoid session cookie
      sign_in(bloomy, store: false)

      render json: {
        email: bloomy.email,
        token: bloomy.authentication_token,
        id: bloomy.id
      }
    else
      render json: { error: 'email ou mot de passe inconnu' }, status: 401
    end
  end
end
