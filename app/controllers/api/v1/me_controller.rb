module Api
  module V1
    class MeController < ApplicationController
      before_action :authenticate_user!

      def show
        included = %w(tribes challenges questions)
        render json: JSONAPI::ResourceSerializer.new(UserResource, include: included).serialize_to_hash(UserResource.new(current_user, nil)).to_json
      end
    end
  end
end
