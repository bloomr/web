require 'rails_helper'

RSpec.describe BloomySessionsController, type: :controller do
  describe 'POST' do
    let!(:bloomy) { create(:bloomy, password: 'toto1234') }
    let(:json_response) { JSON.parse(response.body) }

    describe 'POST #create with correct credentials' do
      let(:payload) { { bloomy: { email: bloomy.email, password: 'toto1234' } } }

      before :each do
        expect(controller).to receive(:sign_in).with(bloomy, store: false)
        post :create, payload
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns email and token' do
        expect(json_response['email']).to eq(bloomy.email)
        expect(json_response['token']).to eq(bloomy.reload.authentication_token)
      end
    end

    describe 'POST #create with wrong credentials' do
      let(:payload) { { bloomy: { email: bloomy.email, password: 'wrong' } } }

      before :each do
        request.env['devise.mapping'] = Devise.mappings[:bloomy]
        post :create, payload
      end

      it 'returns http unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error' do
        expect(json_response).to eq({ 'error' => 'email ou mot de passe inconnu' })
      end
    end
  end
end
