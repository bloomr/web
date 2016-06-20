require 'rails_helper'

RSpec.describe Api::V1::MeController, type: :request do
  include Warden::Test::Helpers

  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/vnd.api+json',
      'ACCEPT' => 'application/vnd.api+json'
    }
  end

  let(:body) { JSON.parse(response.body) }
  let(:user) { create(:user_published_with_questions) }
  subject { response }

  describe 'GET me #show' do
    before :each do
      Warden.test_mode!
      login_as(user, scope: :user)
      get '/api/v1/me', nil, headers
    end

    it { is_expected.to have_http_status(:success) }
    it 'send the right attributes' do
      keys = body['data']['attributes'].keys
      expected_keys = ['job-title', 'first-name', 'stats', 'avatar-url']
      expect(keys).to match(expected_keys)
    end
  end
end
