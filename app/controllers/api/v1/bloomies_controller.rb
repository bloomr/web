module Api
  module V1
    class BloomiesController < ApplicationController
      def index
        bloomy = Bloomy.first
        render json: bloomy
      end
    end
  end
end
