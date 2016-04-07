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
      post :create, { user: { email: 'loulou@lou.com', job_title: 'job', first_name: 'loulou' } }
    end

    it 'returns redirect to enrollement_thanks' do
      expect(response).to redirect_to(enrollment_thanks_path)
    end

    it 'send a mail' do
      mail = ActionMailer::Base.deliveries.last
      real_typeform_link = mail.to_s[/(https:\/\/bloomr.*)" target/m,1].gsub("\r\n",'')
      typeform_link = 'https://bloomr.typeform.com/to/FIuafU?email=3Dloulou@lo=u.com&amp;metier=3Djob&amp;prenom=3Dloulou'
      expect(real_typeform_link).to eq typeform_link
      expect(mail['to'].value).to eq('loulou@lou.com')
    end
  end

end
