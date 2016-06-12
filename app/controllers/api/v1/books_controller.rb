module Api
  module V1
    class BooksController < ApplicationController
      def search
        books = Amazon::Search.books(params[:keywords])
        data = books.map do |book|
          {
            id: book.isbn,
            type: 'books',
            attributes: {
              author: book.author,
              isbn: book.isbn,
              title: book.title,
              'image-url': book.image_url
            }
          }
        end
        render json: { data: data }
      end
    end
  end
end
