class PortraitsController < ApplicationController

  def index
    params[:page] = params[:page].to_i
    if params[:page] == 0
      params[:page] = 1
    end
    @portraits = User.where("published = ? and job_title IS NOT NULL", true).limit(12).offset(12* (params[:page]-1))
  end

  def show
    @portrait = User.where.not(:job_title => nil).find(params[:id])
  end

end
