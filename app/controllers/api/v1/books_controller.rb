module Api
  module V1
    class BooksController < BaseController
      def search
        in_english = params[:inEnglish].nil? ? false : params[:inEnglish]
        books = Amazon::Search.books(params[:keywords], in_english)
        data = books.map do |book|
          {
            author: book.author,
            isbn: book.isbn,
            title: book.title,
            imageUrl: book.image_url
          }
        end
        render json: data
      end
    end
  end
end
