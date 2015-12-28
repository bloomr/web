class MeController < ApplicationController

  before_action :authenticate_user!

  def show
  end

  def update
    current_user.update(user_params)
    redirect_to me_path
  end

  private
  def user_params
    params.require(:user).permit(:email, questions_attributes: [:id, :answer])
  end

end
