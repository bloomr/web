module Api
  module V1
    class BaseController < JSONAPI::ResourceController
      def context
        { user: current_user }
      end

      rescue_from Exceptions::NotAuthorizedError do
        render json: { error: 'Forbidden' }, status: 403
      end
    end
  end
end
