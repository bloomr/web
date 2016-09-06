class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  def after_sign_in_path_for(resources)
    case resources
    when User
      me_path
    when AdminUser
      admin_root_path
    when Bloomy
      ENV['DISCOURSE_URL']
    end
  end
end
