require 'rails_helper'

RSpec.describe Api::V1::MissionsController, type: :controller do
  let!(:bloomy) { create(:bloomy) }
  let!(:mission) { Mission.create(prismic_id: '1') }

  describe 'create' do
    context 'when the bloomy is logged' do
      before :each do
        request.headers['X-Bloomy-Token'] = bloomy.authentication_token
        request.headers['X-Bloomy-Email'] = bloomy.email
      end

      context 'when the mission does not exists' do
        it 'creates the mission' do
          post :create, data: { attributes: { prismic_id: '2' }, type: 'mission' }

          expect(response).to have_http_status(:success)
          expect(Mission.find_by(prismic_id: 2)).not_to be_nil
        end
      end

      context 'when the mission exists' do
        it 'returns this mission' do
          post :create, data: { attributes: { prismic_id: '1' }, type: 'mission' }

          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)['data']['id']).to eq(mission.id.to_s)
        end
      end
    end

    context 'when the bloomy is not logged in' do
      it 'returns unauthorized' do
        post :create, {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
