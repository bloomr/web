require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  context 'when a portrait is viewed' do
    let(:user) do
      result = create(:user_published_with_questions, questions_count: 2)
      result.questions << create(:question, published: false)
      result
    end

    before do
      get :show, params: { normalized_job_title: user.normalized_job_title, normalized_first_name: user.normalized_first_name }
    end

    it 'counts the view' do
      expect(User.first.impressionist_count).to eq(1)
    end

    it 'displays only published questions' do
      expect(assigns[:portrait].questions)
        .to match_array(user.questions.published)
    end
  end
end
