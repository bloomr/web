class MeController < ApplicationController

  before_action :authenticate_user!, except: :email_sent

  def show
    render layout: 'home'
  end

  def challenge_1
    current_user.update(user_params[:user]) unless user_params[:user].nil?
    current_user.challenges << Challenge.find_by(name: 'the tribes')
    redirect_to me_path
  end

  def update
    current_user.update(user_params[:user])
    redirect_to me_path
  end

  def email_sent
  end

  private
  def user_params
    params.permit(user: [:email, :job_title, tribe_ids: [], questions_attributes: [:id, :answer]])
  end

end
