class BredController < ApplicationController
  def index
  end

  def create
    password = WeakPassword.instance
    bloomy = Bloomy.create!(bloomy_params.merge(password: password))
    Journey.new(bloomy, password, bred: true)
    redirect_to bred_program_thanks_path
  end

  def thanks
  end

  private

  def bloomy_params
    params.require(:bloomy).permit(:email, :first_name, :age, :source)
  end
end
