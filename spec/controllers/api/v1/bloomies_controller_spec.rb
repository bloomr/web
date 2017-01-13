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

  describe 'update' do
      let(:payload) {
        {
          id: bloomy.id,
          'data': {
            'id': bloomy.id,
            'attributes': { 'first-name': 'updated' },
            'relationships': {
              'missions': { 'data': missions }
            },
            'type': 'bloomies'
          }
        }
      }

      let(:missions) { [{ 'type': 'missions', 'id': mission.id }] }

      context 'when the bloomy is logged' do
        before :each do
          request.headers['X-Bloomy-Token'] = bloomy.authentication_token
          request.headers['X-Bloomy-Email'] = bloomy.email
        end

        context 'with one missions' do
          it 'updates the bloomy' do
            patch :update, payload

            expect(response).to have_http_status(:success)
            expect(bloomy.reload.missions).to match([mission])
          end

          context 'and then with severals missions' do
            let(:missions) { [
              { 'type': 'missions', 'id': mission.id },
              { 'type': 'missions', 'id': mission2.id }]
            }

            it 'updates the bloomy' do
              patch :update, payload

              expect(response).to have_http_status(:success)
              expect(bloomy.reload.missions).to match([mission, mission2])
            end
          end

          it 'returns unauthorized if update another bloomy' do
            payload['id'] = bloomy2.id
            patch :update, payload

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'when the bloomy is not logged' do
        it 'returns unauthorized' do
          patch :update, payload

          expect(response).to have_http_status(:unauthorized)
        end
      end
  end
end
