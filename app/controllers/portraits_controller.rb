class PortraitsController < ApplicationController

  def index
    @portraits = User.where("published = ? and job_title IS NOT NULL", true)
  end

  def show
    @portrait = User.where.not(:job_title => nil).find(params[:id])
  end
end
