class MeController < ApplicationController

  before_action :authenticate_user!, except: :email_sent

  def show
  end

  def update
    current_user.update(user_params)
    redirect_to me_path
  end

  def email_sent
  end

  private
  def user_params
    params.require(:user).permit(:email, :job_title, tribe_ids: [], questions_attributes: [:id, :answer])
  end

end
