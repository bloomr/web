module Api
  module V1
    class BloomiesController < ApplicationController
      skip_before_filter :verify_authenticity_token
      def show
        bloomy = Bloomy.find(params[:id])
        render json: bloomy, include: ['missions']
      end

      def update
        h = create_params
        bloomy = Bloomy.update(h[:id], h)
        render json: bloomy
      end

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end
    end
  end
end
