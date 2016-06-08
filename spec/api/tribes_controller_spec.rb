require 'rails_helper'

RSpec.describe Api::V1::TribesController, type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  subject { response }

  def expect_no_route
    expect do
      yield
    end.to raise_error(ActionController::RoutingError)
  end

  describe 'GET all #tribes' do
    before :each do
      get '/api/v1/tribes', nil, headers
    end

    it { is_expected.to have_http_status(:success) }
  end

  describe 'GET one #tribe' do
    it 'has not route' do
      expect_no_route { get '/api/v1/tribes/1', nil, headers }
    end
  end

  describe 'PATCH #tribes' do
    it 'has not route' do
      expect_no_route { patch '/api/v1/tribes/1', nil, headers }
    end
  end

  describe 'POST #tribes' do
    it 'has not route' do
      expect_no_route { post '/api/v1/tribes', nil, headers }
    end
  end
end
