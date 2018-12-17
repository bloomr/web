module Api
  module V1
    class MissionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      acts_as_token_authentication_handler_for Bloomy, fallback: :none
      before_action :check_bloomy

      def create
        render json: Mission.find_or_create_by(create_params)
      end

      private

      def check_bloomy
        render json: {}, status: :unauthorized if current_bloomy.nil?
      end

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end
    end
  end
end
