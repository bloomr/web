module Api
  module V1
    class BooksController < ApplicationController
      def search
        books = Amazon::Search.books(params[:keywords])
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
