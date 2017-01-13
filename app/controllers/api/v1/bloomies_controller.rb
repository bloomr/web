module Api
  module V1
    class BloomiesController < ApplicationController
      skip_before_filter :verify_authenticity_token
      acts_as_token_authentication_handler_for Bloomy, fallback: :none
      before_action :check_bloomy

      def show
        bloomy = Bloomy.find(params[:id])
        render json: bloomy, include: ['missions']
      end

      def update
        h = create_params
        bloomy = Bloomy.update(h[:id], h)
        render json: bloomy
      end

      private

      def check_bloomy
        if current_bloomy.nil? || current_bloomy.id != params[:id].to_i
          render json: {}, status: :unauthorized
        end
      end

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end
    end
  end
end
