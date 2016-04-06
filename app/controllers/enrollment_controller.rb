class EnrollmentController < ApplicationController

  def index
    @user = User.new
    render layout: 'home'
  end

  def create
    redirect_to enrollment_thanks_path
  end

  def thanks
    render layout: 'home'
  end
end
