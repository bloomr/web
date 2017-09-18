require 'rails_helper'

RSpec.describe PaymentController, type: :controller do
  let!(:default_campaign) do
    FactoryGirl.create(:campaign, partner: 'default', standard_price: '35.0', premium_price: '50.0')
  end

  let!(:sujetdubac_campaign) do
    FactoryGirl.create(:campaign, partner: 'sujetdubac', standard_price: '13.0', 'premium_price': '26')
  end

  let!(:standard_program) { ProgramTemplate.create(name: 'standard', intercom: false, discourse: true) }
  let!(:premium_program)  { ProgramTemplate.create(name: 'premium', intercom: true, discourse: true) }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #thanks' do
    it 'returns http success' do
      get :thanks
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:stripes_args) do
      { amount: amount, currency: 'eur', source: '1234',
        description: '1 Parcours Bloomr',
        receipt_email: 'loulou@lou.com', metadata: metadata }
    end

    let(:metadata) do
      { 'info_client' => 'loulou - 44 ans - loulou@lou.com',
        'source' => 'default', 'gift' => false }
    end

    let(:bloomy) do
      {
        first_name: 'loulou',
        name: 'yop',
        email: 'loulou@lou.com',
        age: '44',
        password: 'yopyopyop'
      }
    end

    let(:payload) { { bloomy: bloomy, stripeToken: '1234', program_name: 'standard' } }

    subject { Bloomy.first }

    before do
      allow(Stripe::Charge).to receive(:create)
      expect(Intercom::Wrapper).to receive(:create_bloomy)
    end

    describe 'the bloomy creation' do
      before { post :create, payload }

      it { expect(subject.first_name).to eq('loulou') }
      it { expect(subject.name).to eq('yop') }
      it { expect(subject.email).to eq('loulou@lou.com') }
      it { expect(subject.age).to eq(44) }
      it { expect(subject.valid_password?('yopyopyop')).to be(true) }
    end

    context 'if its a premium program' do
      before { post :create, payload.merge(program_name: 'premium') }
      it { expect(subject.programs.first.name).to eq('premium') }
    end

    context 'if its a standard program' do
      before { post :create, payload.merge(program_name: 'standard') }
      it { expect(subject.programs.first.name).to eq('standard') }
    end

    context 'if it s a gift' do
      let(:payload) { super().merge(gift: true, buyer_email: 'money@rich.com') }
      let(:stripes_args) { super().merge(receipt_email: 'money@rich.com') }
      let(:metadata) { super().merge('gift' => true) }
      let(:amount) { 3500 }

      it 'charges the right amount and redirect to payment_thanks' do
        expect(Stripe::Charge).to receive(:create).with(stripes_args)
        post :create, payload
        expect(response).to redirect_to(payment_thanks_path + '?gift=true')
      end
    end

    describe 'the stripe charges' do
      after do
        post :create, payload
        expect(response).to redirect_to(payment_thanks_path + '?email=loulou%40lou.com')
      end

      context 'with the standard program' do
        context 'with no cookie' do
          let(:amount) { 3500 }

          it 'charges the right amount and redirect to payment_thanks' do
            expect(Stripe::Charge).to receive(:create).with(stripes_args)
          end
        end

        context 'with sujetdubac cookie' do
          let(:metadata) { super().merge('source' => 'sujetdubac') }
          let(:amount) { 1300 }

          it 'charge the right amount and set the right source' do
            request.cookies[:partner] = 'sujetdubac'
            expect(Stripe::Charge).to receive(:create).with(stripes_args)
          end
        end
      end

      context 'with the premium program' do
        let(:payload) { super().merge('program_name' => 'premium') }

        context 'with no cookie' do
          let(:amount) { default_campaign.amount('premium') }

          it 'charges the right amount and redirect to payment_thanks' do
            expect(Stripe::Charge).to receive(:create).with(stripes_args)
          end
        end

        context 'with sujetdubac cookie' do
          let(:metadata) { super().merge('source' => 'sujetdubac') }
          let(:amount) { sujetdubac_campaign.amount('premium') }

          it 'charge the right amount and set the right source' do
            request.cookies[:partner] = 'sujetdubac'
            expect(Stripe::Charge).to receive(:create).with(stripes_args)
          end
        end
      end
    end
  end
end
