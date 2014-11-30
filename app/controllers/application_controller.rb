class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  if ENV['BASIC_AUTH'] && ENV['BASIC_AUTH'].downcase == 'true'
    http_basic_authenticate_with :name => ENV['BASIC_AUTH_USER'], :password => ENV['BASIC_AUTH_PASSWORD']
  end

  def https_enabled?
    #active by default
    ENV['ONLY_HTTP_ENABLE'] != 'true'
  end

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

end
