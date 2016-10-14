class TribesController < ApplicationController
  def index
    @tribes = Tribe.all
    @page = params[:page].to_i
    @portraits = User.active_ordered.paged(page: @page)
    @popular_keywords = Keyword.popular_keywords
  end

  def show
    @tribe = Tribe.find_by normalized_name: params[:id]
    ids = @tribe.users.active_ordered.pluck(:id)
    index = User.includes(:questions).find(ids).group_by(&:id)
    @users = ids.map { |i| index[i].first }

    render layout: 'new_home'
  end
end
