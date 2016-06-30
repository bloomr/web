class EnrollmentController < ApplicationController
  def index
    @user = User.new
    render layout: 'home'
  end

  def create
    user = User.create_with_default_questions!(user_params)
    notif(user_params)
    sign_in(user)
    redirect_to me_path
  rescue StandardError => e
    flash[:errors] = e.message
    redirect_to enrollment_index_path
  end

  private

  def notif(user_params)
    Mailchimp.send_notif_about_bloomeur(
      user_params[:email], user_params[:first_name], user_params[:job_title]
    )
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :password, :job_title)
  end
end
