module Api
  module V1
    class BookResource < JSONAPI::Resource
      before_create :authorize_create

      attributes :title, :author, :image_url, :isbn, :asin

      relationship :user, to: :many

      private

      def authorize_create
        fail Exceptions::NotAuthorizedError if context[:user].nil?
      end
    end
  end
end
