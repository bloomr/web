class PortraitsController < ApplicationController

  def index
    @portraits = User.where.not(:job_title => nil)
  end

  def show
    @portrait = User.where.not(:job_title => nil).find(params[:id])
  end
end
