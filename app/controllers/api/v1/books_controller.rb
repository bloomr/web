module Api
module V1
    class BooksController < BaseController
      def search
        in_english = params[:inEnglish] == 'true' ? true : false
        books = Amazon::Search.books(params[:keywords], in_english)
        data = books.map do |book|
          {
            author: book.author,
            isbn: book.isbn,
            title: book.title,
            imageUrl: book.image_url,
            asin: book.asin
          }
        end
        render json: data
      end
    end
  end
end
