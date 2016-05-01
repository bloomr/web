require 'rails_helper'

RSpec.describe PortraitsController, :type => :controller do

  context 'when a portrait is viewed' do

    let(:user) do
      result = create(:user_published_with_questions, questions_count: 2)
      result.questions << create(:question, published: false)
      result
    end

    before do
      get :show, id: user.id
    end

    it 'counts the view' do
      expect(User.first.impressionist_count).to eq(1)
    end

    it 'displays only published questions' do
        expect(assigns[:portrait].questions).to match_array(user.questions.published)
    end
  end

end
