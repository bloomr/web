require 'rails_helper'

RSpec.describe Api::V1::ProgramsController, type: :controller do
  let!(:program) { create(:program) }
  let!(:program2) { create(:program) }
  let!(:bloomy) { create(:bloomy, programs: [program]) }
  let!(:bloomy2) { create(:bloomy) }
  let!(:mission) { Mission.create(prismic_id: '1') }
  let!(:mission2) { Mission.create(prismic_id: '2') }

  describe 'show' do
    context 'when the bloomy is logged' do
      it 'returns the program' do
        get :show, id: program.id,
                   'bloomy_email': bloomy.email,
                   'bloomy_token': bloomy.authentication_token

        expect(response).to have_http_status(:success)
      end

      it 'returns unauthorized if another bloomy is required' do
        get :show, id: program2.id,
                   'bloomy_email': bloomy.email,
                   'bloomy_token': bloomy.authentication_token

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the bloomy is not logged in' do
      it 'returns unauthorized' do
        get :show, id: program.id
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'update' do
      let(:payload) {
        {
          id: program.id,
          'data': {
            'id': program.id,
            'attributes': { 'name': 'updated' },
            'relationships': {
              'missions': { 'data': missions }
            },
            'type': 'programs'
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
          it 'updates the program' do
            patch :update, payload

            expect(response).to have_http_status(:success)
            expect(program.reload.missions).to match([mission])
          end

          context 'and then with severals missions' do
            let(:missions) { [
              { 'type': 'missions', 'id': mission.id },
              { 'type': 'missions', 'id': mission2.id }]
            }

            it 'updates the program' do
              patch :update, payload

              expect(response).to have_http_status(:success)
              expect(program.reload.missions).to match([mission, mission2])
            end
          end

          it 'returns unauthorized if update another program' do
            payload['id'] = program2.id
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
