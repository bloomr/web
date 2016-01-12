require 'rails_helper'

RSpec.describe PortraitsController, :type => :controller do

  context 'when a portrait is viewed' do

    let(:user) { create(:user_with_questions) }

    before do
      get :show, id: user.id
    end

    it 'the view is count' do
      expect(User.first.impressionist_count).to eq(1)
    end

  end

end
