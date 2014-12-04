class ParticiperController < ApplicationController

  def index
    @email = params[:email]
    @metier = params[:metier]
  end

end
