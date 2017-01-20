require 'rails_helper'

RSpec.describe Api::V1::BloomiesController, type: :controller do
  let!(:bloomy) { create(:bloomy) }
  let!(:bloomy2) { create(:bloomy) }
  let!(:mission) { Mission.create(prismic_id: '1') }
  let!(:mission2) { Mission.create(prismic_id: '2') }

  describe 'show' do
    context 'when the bloomy is logged' do
      it 'returns the logged user' do
        get :show, id: bloomy.id,
                   'bloomy_email': bloomy.email,
                   'bloomy_token': bloomy.authentication_token

        expect(response).to have_http_status(:success)
      end

      it 'returns unauthorized if another bloomy is required' do
        get :show, id: bloomy2.id,
                   'bloomy_email': bloomy.email,
                   'bloomy_token': bloomy.authentication_token

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the bloomy is not logged in' do
      it 'returns unauthorized' do
        get :show, id: 1
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
