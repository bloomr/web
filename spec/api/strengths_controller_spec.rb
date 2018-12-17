require 'rails_helper'

RSpec.describe Api::V1::StrengthsController, type: :request do
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

  describe 'GET all #strengths' do
    before :each do
      3.times do |i|
        Strength.create(name: "strength#{i}")
      end
      get '/api/v1/strengths', headers: headers
    end

    it { is_expected.to have_http_status(:success) }

    it 'returns only the published strengths' do
      expect(body['data'].count).to eq(3)
      expect(body['data'][0]['attributes']['name']).to eq('strength0')
    end
  end

  describe 'PATCH #strengths' do
    it 'has not route' do
      expect_no_route { patch '/api/v1/strengths/1', headers: headers }
    end
  end

  describe 'POST #strengths' do
    it 'has not route' do
      expect_no_route { post '/api/v1/strengths', headers: headers }
    end
  end
end
