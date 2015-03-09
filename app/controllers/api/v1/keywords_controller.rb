module Api
  module V1

    class KeywordsController < ApplicationController

      def index
        keywords = Keyword.joins(:keyword_associations).group("keywords.id").having("count(keyword_associations.id) > 0")
        render json: keywords, :only => [:id, :tag, :description]
      end

    end

  end
end


