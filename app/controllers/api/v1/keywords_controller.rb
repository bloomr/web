module Api
  module V1

    class KeywordsController < ApplicationController

      def index
        render json: Keyword.joins(:keyword_associations).select("distinct keywords.*, count(keyword_associations.id) as popularity").group("keywords.id"), :only => [:id, :tag, :description, :popularity]
      end

    end

  end
end


