require 'rails_helper'

RSpec.describe BredController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:bloomy) do
      { 'first_name' => 'loulou', 'email' => 'loulou@lou.com', 'age' => '44', 'source' => 'bred - s' }
    end
    let(:false_bloomy) { create(:bloomy) }
    let(:payload) { { bloomy: bloomy } }

    before do
      expect(WeakPassword).to receive(:instance).and_return('toto')
      expect(Bloomy).to receive(:create!).with(bloomy.merge('password' => 'toto')).and_return(false_bloomy)
      expect(Journey).to receive(:new).with(false_bloomy, 'toto', bred: true)
    end

    it 'returns http success' do
      post :create, payload
      expect(response).to redirect_to(bred_program_thanks_path)
    end
  end

  describe 'GET #thanks' do
    it 'returns http success' do
      get :thanks
      expect(response).to have_http_status(:success)
    end
  end
end
