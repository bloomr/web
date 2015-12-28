class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to @user
  end

  def user_params
    params.require(:user).permit(:email, questions_attributes: [:id, :answer])
  end
end
