class TagController < ApplicationController
  def show
    @page = params[:page].to_i
    @tag = params[:id]
    @keyword = Keyword.find_by(tag: @tag)
    raise ActionController::RoutingError.new('Not Found') if @keyword.nil?
    @portraits = User.find_published_with_tag(tag: @tag, page: @page)

    # Get the 5 most popular tags
    @popular_keywords = Keyword.popular_keywords
  end
end
