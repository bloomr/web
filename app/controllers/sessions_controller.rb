class SessionsController < Devise::SessionsController
  # allow logout from ember client
  skip_before_action :verify_authenticity_token, only: :destroy
end
