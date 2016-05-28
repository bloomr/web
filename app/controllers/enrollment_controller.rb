class EnrollmentController < ApplicationController
  def index
    @user = User.new
    render layout: 'home'
  end

  def create
    user_hash = params['user']
    EnrollmentMailer.enroll_email(user_hash).deliver_now
    Mailchimp.send_notif_about_bloomeur(
      user_hash[:email], user_hash[:first_name], user_hash[:job_title])
    redirect_to enrollment_thanks_path
  end

  def thanks
    render layout: 'home'
  end
end
