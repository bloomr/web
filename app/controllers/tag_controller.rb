class TagController < ApplicationController
  def show
    @page = params[:page].to_i
    @tag = params[:id].capitalize
    @keyword = Keyword.find_by(tag: @tag)
    if @keyword.nil?
      raise(ActionController::RoutingError.new('Not Found'), 'tag not found')
    end
    @portraits = User.find_published_with_tag(tag: @tag, nb_per_page: 40)

    # Get the 5 most popular tags
    @popular_keywords = Keyword.popular_keywords
  end
end
