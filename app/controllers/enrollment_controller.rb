class EnrollmentController < ApplicationController

  def index
    @user = User.new
    render layout: 'home'
  end

  def create
    user_hash = params['user']
    EnrollmentMailer.enroll_email(user_hash).deliver_now
    redirect_to enrollment_thanks_path
  end

  def thanks
    render layout: 'home'
  end
end
