module Api
  module V1
    class QuestionResource < JSONAPI::Resource
      before_update :authorize_update

      attributes :title, :answer, :description, :step

      relationship :user, to: :one

      private

      def authorize_update
        if context[:user].nil? || @model.user.id != context[:user].id
          fail Exceptions::NotAuthorizedError
        end
      end
    end
  end
end
