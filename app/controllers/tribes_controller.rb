class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
    @page = params[:page].to_i
    @portraits = User.active_ordered.paged(page: @page)
    @popular_keywords = Keyword.popular_keywords
  end

  def show
    @tribe = Tribe.find_by normalized_name: params[:id]
    render layout: 'new_home'
  end
end
