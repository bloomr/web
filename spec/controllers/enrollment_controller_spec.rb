require 'rails_helper'

RSpec.describe EnrollmentController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'when all parameters are sent' do
      before do
        expect(Mailchimp).to receive(:send_notif_about_bloomeur)
        expect(controller).to receive(:sign_in)
        post :create, user: {
          email: 'loulou@lou.com', job_title: 'job',
          first_name: 'loulou', password: 'loulou12'
        }
      end

      it 'returns redirect to enrollement_thanks' do
        expect(response).to redirect_to(me_path)
      end

      it 'creates the user' do
        user = User.find_by(email: 'loulou@lou.com')
        expect(user.first_name).to eq('loulou')
        expect(user.job_title).to eq('job')
        expect(user.valid_password?('loulou12')).to be(true)
      end
    end

    context 'when the password is missing' do
      before do
        expect(Mailchimp).not_to receive(:send_notif_about_bloomeur)
        post :create, user: {
          email: 'loulou@lou.com', job_title: 'job',
          first_name: 'loulou'
        }
      end

      it 'redirects to index with an error' do
        expect(response).to redirect_to(enrollment_index_path)
        expect(flash[:errors]).to be
      end
    end
  end
end
