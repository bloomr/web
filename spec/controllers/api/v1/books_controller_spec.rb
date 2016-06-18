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
end
