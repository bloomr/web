class DiscourseSsoController < ApplicationController
  def sso
    secret = "MY_SECRET_STRING"
    sso = Discourse::SingleSignOn.parse(request.query_string, secret)
    sso.email = "user@email.com"
    sso.name = "Bill Hicks"
    sso.username = "bill@hicks.com"
    sso.external_id = "123" # unique id for each user of your application
    sso.sso_secret = secret

    redirect_to sso.to_url("http://localhost:8080/session/sso_login")
  end
end
