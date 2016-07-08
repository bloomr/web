module Api
  module V1
    class KeywordResource < JSONAPI::Resource
      before_create :authorize_create

      attributes :tag
      relationship :users, to: :many

      private

      def authorize_create
        raise Exceptions::NotAuthorizedError if context[:user].nil?
      end
    end
  end
end
