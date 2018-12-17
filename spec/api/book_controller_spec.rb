require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :request do
  include Warden::Test::Helpers

  def expect_no_route
    expect do
      yield
    end.to raise_error(ActionController::RoutingError)
  end

  def payload
    {
      data: {
        attributes: {
          'author': 'author',
          'isbn': 'isbn',
          'asin': 'asin',
          'title': 'title',
          'image-url': 'imageUrl'
        },
        type: 'books'
      }
    }
  end

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  let(:body) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:book) { Book.first }
  subject { response }

  describe 'create #books' do
    context 'when the user is logged in' do
      before :each do
        Warden.test_mode!
        login_as(user, scope: :user)
        post '/api/v1/books', params: payload.to_json, headers: headers
      end

      it { is_expected.to have_http_status(:success) }
      it 'create the book and give an id' do
        expect(book.author).to eq('author')
        expect(book.isbn).to eq('isbn')
        expect(book.asin).to eq('asin')
        expect(book.title).to eq('title')
        expect(book.image_url).to eq('imageUrl')
        @id_saved = body['data']['id']
        expect(@id_saved).not_to be(nil)
      end

      context 'when the same book is saved' do
        before :each do
          post '/api/v1/books', params: payload.to_json, headers: headers
        end

        it { is_expected.to have_http_status(:success) }
        it 'returns the same id' do
          puts body
          expect(body['data']['id']).not_to be(@id_saved)
        end
      end
    end

    unless ENV['TRAVIS']
      context 'when the user is not logged in' do
        before :each do
          post '/api/v1/books', params: payload.to_json, headers: headers
        end

        it { is_expected.to have_http_status(403) }
      end
    end
  end

  describe 'GET one #books' do
    it 'has no routes' do
      expect_no_route { get '/api/v1/books/1', headers: headers }
    end
  end

  describe 'GET all #books' do
    it 'has no routes' do
      expect_no_route { get '/api/v1/books', headers: headers }
    end
  end

  describe 'Patch all #books' do
    it 'has no routes' do
      expect_no_route { patch '/api/v1/books', headers: headers }
    end
  end
end
