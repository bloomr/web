class PortraitsController < ApplicationController

  def index
    params[:page] = params[:page].to_i
    if params[:page] > 0
      params[:page] = params[:page] - 1
    end

    @portraits = User.find_published_with_love_job_question page: params[:page]
    # Get the 5 most popular tags
    @popular_keywords = Keyword.popular_keywords
  end

  def show
    @portrait = User.where("published = ? and job_title IS NOT NULL", true).find(params[:id])

    # Get the 5 most popular tags
    @popular_keywords = Keyword.popular_keywords
  end

  def next
    redirect_to action: "show", id: (User.next params[:id].to_i).id
  end

  def previous
    redirect_to action: "show", id: (User.previous params[:id].to_i).id
  end

  def aleatoire
    redirect_to action: "show", id: (User.random).id
  end

end
