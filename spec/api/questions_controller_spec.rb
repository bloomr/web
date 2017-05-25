require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :request do
  include Warden::Test::Helpers

  def payload(user_id, question_id)
    {
      data: {
        id: question_id,
        attributes: {
          title: 'question 23',
          answer: 'answer 23'
        },
        relationships: {
          user: {
            data: {
              type: 'users',
              id: user_id
            }
          }
        },
        type: 'questions'
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
  let(:question1) { user.questions.first }
  subject { response }

  def expect_no_route
    expect do
      yield
    end.to raise_error(ActionController::RoutingError)
  end

  describe 'PATCH #questions' do
    context 'when the user is logged in' do
      before :each do
        Warden.test_mode!
        login_as(user, scope: :user)
        patch "/api/v1/questions/#{question1.id}", payload(user.id, question1.id).to_json, headers
        question1.reload
      end

      it { is_expected.to have_http_status(:success) }
      it 'updates the users' do
        expect(question1.title).to eq('question 23')
        expect(question1.answer).to eq('answer 23')
      end
    end

    unless ENV['TRAVIS']
      context 'when the user is not logged in' do
        before :each do
          patch "/api/v1/questions/#{question1.id}", payload(user.id, question1.id).to_json, headers
        end

        it { is_expected.to have_http_status(403) }
      end
    end
  end

  describe 'GET one #questions' do
    it 'has not route' do
      expect_no_route { get "/api/v1/questions/#{question1.id}", nil, headers }
    end
  end

  describe 'POST #questions' do
    it 'has not route' do
      expect_no_route { post '/api/v1/questions', nil, headers }
    end
  end

  describe 'GET all #questions' do
    it 'has not route' do
      expect_no_route { post '/api/v1/questions', nil, headers }
    end
  end
end
