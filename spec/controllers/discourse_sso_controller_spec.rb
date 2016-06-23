require 'rails_helper'

RSpec.describe DiscourseSsoController, type: :controller do
  describe 'GET #sso' do
    it 'returns http success' do
      ENV['DISCOURSE_SECRET'] = 'd836444a9e4084d5b224a60c208dce14'

      nonce = 'cb68251eefb5211e58c00ff1395f0c0b'
      sso = Base64.encode64("nonce=#{nonce}")
      sig = OpenSSL::HMAC.hexdigest('sha256', ENV['DISCOURSE_SECRET'], sso)

      get :sso, sso: sso, sig: sig

      expect(response).to have_http_status(:success)
      expect(assigns(:nonce)).to eq(nonce)
    end
  end

  describe 'POST #login' do
    let!(:bloomy) { Bloomy.create(email: 'loulou@lou.com', password: 'loulou12', first_name: 'loulou') }
    let(:password) { 'loulou12' }
    let(:email) { bloomy.email }
    let(:qs) { 'sig=2828aa29899722b35a2f191d34ef9b3ce695e0e6eeec47deb46d588d70c7cb56&sso=bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI%3D%0A' }

    before do
      ENV['DISCOURSE_URL'] = 'http://discourse'
      post :login, bloomy: { email: email, password: password, query_string: qs }
    end

    context 'when the login is right' do
      it 'returns redirect to discourse' do
        expect(response.location).to start_with("#{ENV['DISCOURSE_URL']}/session/sso_login")
      end
    end

    context 'when the password is wrong' do
      let(:password) { 'wrong' }

      it 'returns redirect to login' do
        expect(response).to redirect_to('/sso?')
        expect(flash[:nop]).to be_present
      end
    end

    context 'when the email is unknown' do
      let(:email) { 'yop@lou.com' }

      it 'returns redirect to login' do
        expect(response).to redirect_to('/sso?')
        expect(flash[:nop]).to be_present
      end
    end
  end
end
