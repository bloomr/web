require 'rails_helper'

RSpec.describe Api::V1::BloomiesController, type: :controller do
  let!(:bloomy) { create(:bloomy, company_name: 'company_name_tip_top') }
  let!(:bloomy2) { create(:bloomy) }
  let!(:mission) { Mission.create(prismic_id: '1') }
  let!(:mission2) { Mission.create(prismic_id: '2') }
  let!(:program) do
    program = Program.create(name: 'program', discourse: true, intercom: true)
    program.missions << mission
    bloomy.programs << program
    program
  end

  let(:body) { JSON.parse(response.body) }

  let(:expected_json) do
    { 'data' => {
      'id' => '1',
      'type' => 'bloomies',
      'attributes' => {
        'first-name' => 'bloomy',
        'email' => 'bloomy5@b.com',
        'coached' => false,
        'company-name' => 'company_name_tip_top',
        'age' => 21
      },
      'relationships' => {
        'programs' => { 'data' => [{ 'id' => '1', 'type' => 'programs' }] }
      }
    },
      'included' => [
        { 'id' => '1',
          'type' => 'programs',
          'attributes' => {
            'name' => 'program',
            'discourse' => true,
            'intercom' => true,
            'ended-at' => nil
          },
          'relationships' => {
            'missions' => {
              'data' => [{ 'id' => '1', 'type' => 'missions' }]
            }
          } },
        { 'id' => '1',
          'type' => 'missions',
          'attributes' => { 'prismic-id' => '1' } }
      ] }
  end

  describe 'show' do
    context 'when the bloomy is logged' do
      before :each do
        get :show, id: bloomy.id,
                   'bloomy_email': bloomy.email,
                   'bloomy_token': bloomy.authentication_token
      end

      it 'returns the logged user' do
        expect(response).to have_http_status(:success)
      end

      describe 'the response' do
        it 'includes programs and missions' do
          expect(body).to eq(expected_json)
        end
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
