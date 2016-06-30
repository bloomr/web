class SessionsController < Devise::SessionsController
  # allow logout from ember client
  skip_before_filter :verify_authenticity_token, only: :destroy
end
