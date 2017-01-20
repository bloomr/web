module Api
  module V1
    class BloomiesController < ApplicationController
      skip_before_filter :verify_authenticity_token
      acts_as_token_authentication_handler_for Bloomy, fallback: :none
      before_action :check_bloomy

      def show
        bloomy = Bloomy.find(params[:id])
        render json: bloomy, include: %w(programs programs.missions)
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
