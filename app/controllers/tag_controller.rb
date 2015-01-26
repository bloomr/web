class TagController < ApplicationController

  def show
    params[:page] = params[:page].to_i
    if params[:page] == 0
      params[:page] = 1
    end
    @tag = params[:id]
    @portraits = User.where("published = ? and job_title IS NOT NULL", true).tagged_with(@tag).limit(12).offset(12* (params[:page]-1)).order(updated_at: :desc)
  end

end
