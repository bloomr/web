class TagController < ApplicationController

  def show
    params[:page] = params[:page].to_i
    if params[:page] == 0
      params[:page] = 1
    end
    @tag = params[:id]
    @keyword = Keyword.find_by(:tag => @tag)
    @portraits = User.joins(:keywords).where("users.published = ? and users.job_title IS NOT NULL AND keywords.tag = ?", true, @tag).select("distinct users.*").limit(12).offset(12* (params[:page]-1)).order(updated_at: :desc)
  end

end
