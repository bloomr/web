class TagController < ApplicationController
  def show
    @keyword = Keyword.find_by(normalized_tag: params[:normalized_tag])
    if @keyword.nil?
      raise(ActionController::RoutingError.new('Not Found'), 'tag not found')
    end
    @portraits = User.find_published_with_tag(tag: @keyword.tag, nb_per_page: 40)

    # Get the 5 most popular tags
    @popular_keywords = Keyword.popular_keywords
  end
end
