require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  include Warden::Test::Helpers

  def payload(id)
    {
      data: {
        id: id,
        attributes: {
          'job-title': 'coder',
          'first-name': 'Simon'
        },
        type: 'users'
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
  let(:user) { create(:user_published_with_questions) }
  subject { response }

  describe 'PATCH #users' do
    context 'when the user is logged in' do
      before :each do
        Warden.test_mode!
        login_as(user, scope: :user)
        patch '/api/v1/users/1', payload(user.id).to_json, headers
        user.reload
      end

      it { is_expected.to have_http_status(:success) }
      it 'updates the users' do
        expect(user.first_name).to eq('Simon')
        expect(user.job_title).to eq('coder')
      end
    end

    context 'when the user is not logged in' do
      before :each do
        patch '/api/v1/users/1', payload(user.id).to_json, headers
      end

      let(:my_payload) { payload(user.id) }
      it { is_expected.to have_http_status(403) }
    end
  end

  describe 'GET one #users' do
    before :each do
      get "/api/v1/users/#{user.id}?include=questions", nil, headers
    end

    it { is_expected.to have_http_status(:success) }
    it 'send the right attributes' do
      keys = body['data']['attributes'].keys
      expected_keys = ['job-title', 'first-name', 'stats', 'avatar-url']
      expect(keys).to match(expected_keys)
    end

    it 'filter the questions and keep only interview' do
      included = body['included']
      expect(included.length).to eq(1)
    end
  end

  describe 'POST #users' do
    it 'has not route' do
      expect do
        post "/api/v1/users/#{user.id}", nil, headers
      end.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET all #users' do
    it 'has not route' do
      expect do
        post '/api/v1/users', nil, headers
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
