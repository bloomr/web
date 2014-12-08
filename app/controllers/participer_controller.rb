class ParticiperController < ApplicationController

  def index
    @user = User.new(:email => params[:email], :job_title => params[:metier])
    love_job_question = Question.new(:identifier => "love_job", :title => "Au fond, qu'est ce qui fait que vous aimez votre métier ?")
    but_exactly_question = Question.new(:identifier => "specifically", :title => "Que faites vous exactement ?")
    @user.questions = [love_job_question, but_exactly_question]
  end

  def create
    @user = User.new(user_params)
    @user.password = Devise.friendly_token.first(8)
     if @user.save
       redirect_to :participer_merci_beaucoup
     else
       render 'participer/index'
     end
  end

  private
  def user_params
    params.require(:user).permit(:email, :job_title, :first_name, questions_attributes: [:identifier, :title, :answer])
  end

end
