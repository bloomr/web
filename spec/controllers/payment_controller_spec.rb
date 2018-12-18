require 'rails_helper'

RSpec.describe PaymentController, type: :controller do
  let!(:default_campaign) { FactoryBot.create(:campaign, partner: 'default') }
  let!(:sujetdubac_campaign) { FactoryBot.create(:campaign, partner: 'sujetdubac') }

  let!(:standard_program) { ProgramTemplate.create(name: 'standard', intercom: false, discourse: true) }
  let!(:premium_program)  { ProgramTemplate.create(name: 'premium', intercom: true, discourse: true) }

  let!(:standard_bundle) { Bundle.create(name: 'standard', program_templates: [standard_program]) }
  let!(:premium_bundle) { Bundle.create(name: 'premium', program_templates: [premium_program]) }

  let!(:std_bundle_campaign) { BundlesCampaign.create(campaign: default_campaign, bundle: standard_bundle, price: 35) }
  let!(:premium_bundle_campaign) { BundlesCampaign.create(campaign: default_campaign, bundle: premium_bundle, price: 50) }

  let!(:sujet_std_bundle_campaign) { BundlesCampaign.create(campaign: sujetdubac_campaign, bundle: standard_bundle, price: 13) }
  let!(:sujet_premium_bundle_campaign) { BundlesCampaign.create(campaign: sujetdubac_campaign, bundle: premium_bundle, price: 26) }

  before do
    default_campaign.bundles_campaigns << std_bundle_campaign << premium_bundle_campaign
    sujetdubac_campaign.bundles_campaigns << sujet_std_bundle_campaign << sujet_premium_bundle_campaign
  end

  describe 'GET #index' do
    before { get :index }

    it { expect(response).to have_http_status(:success) }
  end

  describe 'POST #post_email' do
    let(:program_name) { nil }
    before { post :post_email, params: { bloomy: { email: email }, program_name: program_name } }

    context 'when the email is not known' do
      let(:email) { 'not-known@toto.com' }

      it { expect(response).to redirect_to(payment_identity_path(program_name: 'standard', email: email)) }

      context 'when the program is premium' do
        let(:program_name) { 'premium' }

        it { expect(response).to redirect_to(payment_identity_path(program_name: 'premium', email: email)) }
      end
    end

    context 'when the email is known' do
      let(:bloomy) { create(:bloomy) }
      let(:email) { bloomy.email }

      it { expect(response).to redirect_to(payment_card_path(program_name: 'standard', bloomy_id: bloomy.id)) }

      context 'and the bloomy already has the program' do
        before do
          bloomy.programs << standard_program.to_program
          post :post_email, params: { bloomy: { email: email }, program_name: program_name }
        end

        it { expect(response).to redirect_to(payment_index_path(program_name: 'standard')) }
        it { expect(flash[:error]).not_to be_nil }
      end
    end
  end

  describe 'GET #identity' do
    before { get :identity, params: { program_name: 'standard', email: 'loulou@lou.com' } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:bloomy).email).to eq('loulou@lou.com') }
    it { expect(assigns(:program_name)).to eq('standard') }
  end

  describe 'POST #create_bloomy' do
    let(:bloomy_params) do
      {
        email: 'lou@lou.com',
        name: 'name',
        first_name: 'first_name',
        age: 43,
        password: password,
        cgu_accepted: true
      }
    end
    let(:bloomy) { Bloomy.find_by(email: 'lou@lou.com') }

    before do
      puts 'before'
      post :create_bloomy, params: { bloomy: bloomy_params, program_name: 'standard' }
    end

    context 'when everything is fine' do
      let(:password) { 'tiptop123' }
      before { bloomy.reload }

      it { expect(response).to redirect_to(payment_card_path(program_name: 'standard', bloomy_id: bloomy.id)) }

      it { expect(bloomy.email).to eq('lou@lou.com') }
      it { expect(bloomy.name).to eq('name') }
      it { expect(bloomy.first_name).to eq('first_name') }
      it { expect(bloomy.age).to eq(43) }
      it { expect(bloomy.valid_password?('tiptop123')).to be(true) }
      it { expect(bloomy.cgu_accepted?).to be(true) }
    end

    context 'when the password is missing' do
      let(:password) { nil }

      it { expect(response).to redirect_to(payment_identity_path(program_name: 'standard', email: 'lou@lou.com')) }
      it { expect(flash[:error]).not_to be_nil }
    end
  end

  describe 'GET #card' do
    before { get :card, params: { program_name: 'standard', bloomy_id: bloomy.id } }

    context 'if the bloomy is known' do
      let(:bloomy) { create(:bloomy) }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:bloomy_id).to_i).to eq(bloomy.id) }
      it { expect(assigns(:program_name)).to eq('standard') }
    end

    context 'if the bloomy already has the program' do
      let(:bloomy) { create(:bloomy, programs: [standard_program.to_program]) }

      it { expect(response).to redirect_to(payment_index_path) }
    end

    context 'if the bloomy is unknown' do
      let(:bloomy) { Bloomy.new(id: 999) }

      it { expect(response).to redirect_to(payment_index_path(program_name: 'standard')) }
      it { expect(flash[:error]).not_to be_nil }
    end
  end

  describe 'POST #charge' do
    let(:bloomy) { create(:bloomy) }
    let(:cookie_partner) { nil }

    let(:stripes_args) do
      { amount: amount, currency: 'eur', source: '1234',
        description: '1 Accès Bloomr',
        receipt_email: bloomy.email, metadata: metadata }
    end

    let(:metadata) do
      { 'info_client' => "#{bloomy.first_name} - #{bloomy.age} ans - #{bloomy.email}",
        'source' => 'default', 'program_name' => 'standard' }
    end

    let(:payload) { { bloomy_id: bloomy.id, stripeToken: '1234', program_name: 'standard' } }

    context 'when there are no pb with stripe' do
      before do
        allow(Stripe::Charge).to receive(:create)
        # TODO: checker les parameteres intercom

        if cookie_partner.present?
          request.cookies[:partner] = 'sujetdubac'
        end

        post :charge, params: payload
        bloomy.reload
      end

      context 'if its a standard program' do
        let(:amount) { 3500 }

        it { expect(bloomy.programs.first.name).to eq('standard') }
        it { expect(Stripe::Charge).to have_received(:create).with(stripes_args) }
      end

      context 'if its a premium program' do
        let(:amount) { 5000 }
        let(:metadata) { super().merge('program_name' => 'premium') }
        let(:payload)  { super().merge('program_name' => 'premium') }

        it { expect(bloomy.programs.first.name).to eq('premium') }
        it { expect(Stripe::Charge).to have_received(:create).with(stripes_args) }
      end

      context 'with sujetdubac cookie' do
        let(:metadata) { super().merge('source' => 'sujetdubac') }
        let(:amount) { 1300 }
        let(:cookie_partner) { 'sujetdubac' }

        it { expect(Stripe::Charge).to have_received(:create).with(stripes_args) }
      end
    end

    context 'if there is a pb with strip' do
      before do
        allow(Stripe::Charge).to receive(:create).and_raise('nop')
        post :charge, params: payload
        bloomy.reload
      end

      it { expect(response).to redirect_to(payment_card_path(program_name: 'standard', bloomy_id: bloomy.id)) }
      it { expect(flash[:error]).to eq('nop') }
    end

    context 'if the bloomy is unknown' do
      before { post :charge, params: payload.merge(bloomy_id: 999) }

      it { expect(response).to redirect_to(payment_index_path(program_name: 'standard')) }
      it { expect(flash[:error]).not_to be_nil }
    end

    context 'if the bloomy already has the program' do
      let(:bloomy) { create(:bloomy, programs: [standard_program.to_program]) }

      before { post :charge, params: payload }

      it { expect(response).to redirect_to(payment_index_path) }
      it { expect(flash[:error]).not_to be_nil }
    end
  end

  describe 'GET #thanks' do
    subject { get :thanks }

    it { is_expected.to have_http_status(:success) }
  end
end
