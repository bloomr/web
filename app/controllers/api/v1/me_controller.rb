module Api
  module V1
    class MeController < ApplicationController
      before_action :authenticate_user!
      # because used in ember
      skip_before_action :verify_authenticity_token

      def show
        included = %w(tribes questions challenges keywords)
        render json: JSONAPI::ResourceSerializer.new(UserResource, include: included)
          .serialize_to_hash(UserResource.new(current_user, nil)).to_json
      end

      def photo
        current_user.avatar = params['avatar']
        current_user.save
        render json: { avatarUrl: current_user.avatar.url('thumb') }
      end
    end
  end
end
