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
            'ended-at' => nil,
            'started-at' => nil
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

  describe 'create' do
    let(:first_name) { 'first_name' }
    let(:password) { 'password' }
    let(:contract) { create(:contract) }
    let(:bundle) { create(:bundle, :with_program_template, contracts: [contract]) }
    let!(:already_registered) { create(:bloomy) }
    let(:created_bloomy) { Bloomy.last }

    let(:key) { contract.key }
    let(:bundle_name) { bundle.name }
    let(:email) { 'email@available.fr' }

    let(:params) do
      {
        first_name: first_name,
        password: password,
        email: email,
        key: key,
        bundle_name: bundle_name
      }
    end

    let(:body) { JSON.parse(response.body) }

    before { post :create, params }

    context 'when the key match a contract' do
      context 'when a corresponding bundle exist' do
        context 'when the bloomy email is available' do

          it { expect(response).to have_http_status(:ok) }
          it do
            expect(created_bloomy).to have_attributes(
              first_name: first_name,
              email: email,
              company_name: contract.company_name,
              coached: true
            )

            expect(created_bloomy.programs.map(&:name)).to match(bundle.program_templates.map(&:name))
          end
        end

        context 'when the bloomy email is not available' do
          let(:email) { already_registered.email }

          it { expect(response).to have_http_status(:unprocessable_entity) }
          it { expect(body).to eq({'error' => ["Email n'est pas disponible"]}) }
        end
      end

      context 'when a corresponding bundle does not exist' do
        let(:bundle_name) { 'unknown bundle' }

        it { expect(response).to have_http_status(:unauthorized) }
        it { expect(body).to eq({'error' => "Votre bundle est inconnu. Peut-être y a-t-il une faute dans l\'url ?"}) }
      end
    end

    context 'when the key does not match' do
      let(:key) { 'unknown key' }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(body).to eq({'error' => "Votre entreprise est inconnue. Peut-être y a-t-il une faute dans l\'url ?"}) }
    end
  end
end
