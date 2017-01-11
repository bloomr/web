module Api
  module V1
    class MissionsController < ApplicationController
      skip_before_filter :verify_authenticity_token
      def create
        mission = Mission.find_or_create_by(create_params)
        render json: mission
      end

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end
    end
  end
end
