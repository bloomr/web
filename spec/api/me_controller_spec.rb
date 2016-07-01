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
      expected_keys = ['job-title', 'first-name', 'stats', 'avatar-url', 'do-authorize']
      expect(keys).to match(expected_keys)
    end
  end

  describe 'POST me #photo' do
    let(:user) { create(:user_published_with_questions) }

    before :each do
      Warden.test_mode!
      login_as(user, scope: :user)
    end

    it 'saves the new photo and return the new avatar url' do
      expect(user).to receive(:avatar=).with('binary_photo')
      avatar_double = double('avatar', url: 'toto.png')
      expect(user).to receive(:avatar).and_return(avatar_double)
      expect(user).to receive(:save).twice # dont know ...

      post '/api/v1/me/photo', avatar: 'binary_photo'

      expect(body['avatarUrl']).to eq('toto.png')
    end
  end
end
