require 'rails_helper'

RSpec.describe Amazon::Search, type: :model do
  before :each do
    allow(HTTParty).to receive(:get)
    ENV['AWS_PARTNER_ACCESS_KEY_ID'] = 'aws_id'
    ENV['AWS_PARTNER_SECRET_KEY'] = 'aws_secret'
  end

  describe '#search' do
    let(:result) { Amazon::Search.books(keywords, false) }

    context 'when no keyword is provided' do
      let(:keywords) { nil }

      it 'returns an empty array' do
        expect(result).to match_array([])
      end
    end

    context 'when an error code is returned' do
      let(:keywords) { 'legitimate keywords' }

      before :each do
        allow(HTTParty).to receive(:get)
          .and_return(double('response', code: 500))
      end

      it 'returns an empty array' do
        expect(result).to match_array([])
      end
    end

    context 'when a response is returned' do
      let(:keywords) { 'legitimate keywords' }
      let(:book) { Book.new }

      before :each do
        allow(HTTParty).to receive(:get)
          .and_return(double('response', code: 200, body: {}))
        allow(Amazon::Response).to receive(:new)
          .and_return(double('amz response', books: [book]))
      end

      it 'returns a book' do
        expect(result).to match([book])
      end
    end
  end
end
