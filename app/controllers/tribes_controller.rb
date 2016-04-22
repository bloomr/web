class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
    @page = params[:page].to_i
    @portraits = User.find_published_with_love_job_question page: @page
    @popular_keywords = Keyword.popular_keywords
  end

  def show
    @tribe = Tribe.find_by normalized_name: params[:id]
  end
end
