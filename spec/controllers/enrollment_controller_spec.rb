require 'rails_helper'

RSpec.describe EnrollmentController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #thanks' do
    it 'returns http success' do
      get :thanks
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before do
      post :create, { user: { email: 'loulou@lou.com' } }
    end

    it 'returns redirect to enrollement_thanks' do
      expect(response).to redirect_to(enrollment_thanks_path)
    end

    it 'send a mail' do
      mail = ActionMailer::Base.deliveries.last
      expect(mail['to'].value).to eq('loulou@lou.com')
    end
  end

end
