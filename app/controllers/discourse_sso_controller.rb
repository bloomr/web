class DiscourseSsoController < ApplicationController
  def sso
    secret = ENV['DISCOURSE_SECRET']
    sso = Discourse::SingleSignOn.parse(request.query_string, secret)
    @query_string = request.query_string
    @nonce = sso.nonce
    @bloomy = Bloomy.new
  end

  def login
    bloomy = Bloomy.find_by_email(params[:bloomy][:email])
    if bloomy.nil? || !bloomy.valid_password?(params[:bloomy][:password])
      flash[:nop] = 'Raté, essaye encore'
      return redirect_to "#{sso_path}?#{params[:query_string]}"
    end

    sso = Discourse::SingleSignOn.new
    sso.nonce = params[:nonce]
    secret = ENV['DISCOURSE_SECRET']
    sso.email = bloomy.email
    sso.username = bloomy.first_name
    sso.external_id = bloomy.id
    sso.sso_secret = secret

    redirect_to sso.to_url("#{ENV['DISCOURSE_URL']}/session/sso_login")
  end
end
