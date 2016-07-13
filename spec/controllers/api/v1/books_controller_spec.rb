require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  describe 'search' do
    it 'search in french by default' do
      expect(Amazon::Search).to receive(:books)
        .with('toto', false).and_return([])
      get :search, keywords: 'toto'
    end

    it 'search in english if asked' do
      expect(Amazon::Search).to receive(:books)
        .with('toto', true).and_return([])
      get :search, keywords: 'toto', inEnglish: true
    end

    it 'do not search in english if not asked' do
      expect(Amazon::Search).to receive(:books)
        .with('toto', false).and_return([])
      get :search, keywords: 'toto', inEnglish: false
    end
  end

  let(:book_hash) { { title: 'title', author: 'author', isbn: 'isbn', image_url: 'imageUrl', asin: 'asin' } }
  let(:book) { Book.new(book_hash) }

  it 'serializes correctly' do
    expect(Amazon::Search).to receive(:books).and_return([book])
    get :search, keywords: 'toto'
    expect(JSON.parse(response.body)[0]).to eq({
      'title' => 'title',
      'author' => 'author',
      'isbn' => 'isbn',
      'imageUrl' => 'imageUrl',
      'asin' => 'asin'
    })
  end
end
