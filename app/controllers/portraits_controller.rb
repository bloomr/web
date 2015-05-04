class PortraitsController < ApplicationController

  def index
    params[:page] = params[:page].to_i
    if params[:page] == 0
      params[:page] = 1
    end
    @portraits = User.where("published = ? and job_title IS NOT NULL", true).limit(12).offset(12* (params[:page]-1)).order(updated_at: :desc)

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
    offset = rand(User.where("published = ? and job_title IS NOT NULL", true).count())
    portrait = User.where("published = ? and job_title IS NOT NULL", true).offset(offset).first

    redirect_to action: "show", id: portrait.id
  end

end
