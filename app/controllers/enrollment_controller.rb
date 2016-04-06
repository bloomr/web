class EnrollmentController < ApplicationController

  def index
    @user = User.new
    render layout: 'home'
  end

  def create
  end
end
