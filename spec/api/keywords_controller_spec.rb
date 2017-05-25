require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :request do
  include Warden::Test::Helpers

  let(:user) { create(:user) }
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  subject { response }

  let(:body) { JSON.parse(response.body) }

  def expect_no_route
    expect do
      yield
    end.to raise_error(ActionController::RoutingError)
  end

  describe 'GET all #keywords' do
    before :each do
      published_keyword = Keyword.create(tag: 'publish')
      expect(Keyword).to receive(:published).and_return([published_keyword])
      get '/api/v1/keywords', nil, headers
    end

    it { is_expected.to have_http_status(:success) }
    it 'returns only the published keyword' do
      expect(body['data'].count).to eq(1)
      expect(body['data'][0]['attributes']['tag']).to eq('publish')
    end
  end

  describe 'GET one #keyword' do
    it 'has not route' do
      expect_no_route { get '/api/v1/keywords/1', nil, headers }
    end
  end

  describe 'PATCH #keywords' do
    it 'has not route' do
      expect_no_route { patch '/api/v1/keywords/1', nil, headers }
    end
  end

  describe 'POST #keywords' do
    let(:payload) do
      {
        data: {
          attributes: {
            'tag': 'new'
          },
          type: 'keywords'
        }
      }
    end

    context 'when the user is logged in' do
      before :each do
        Warden.test_mode!
        login_as(user, scope: :user)
        post '/api/v1/keywords', payload.to_json, headers
      end

      it 'creates the keyword' do
        expect(Keyword.count).to eq(1)
      end
    end

    unless ENV['TRAVIS']
      context 'when the user is not logged in' do
        before :each do
          post '/api/v1/keywords', payload.to_json, headers
        end

        it { is_expected.to have_http_status(403) }
      end
    end
  end
end
