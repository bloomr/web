module Api
  module V1
    class BookProcessor < JSONAPI::Processor
      def create_resource
        book = Book.find_by(isbn: params[:data][:attributes][:isbn])
        return super if book.nil?
        resource = resource_klass.new(book, context)
        JSONAPI::ResourceOperationResult.new(:created, resource)
      end
    end
  end
end
