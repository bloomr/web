require 'rails_helper'

RSpec.describe PaymentController, type: :controller do

  before do
    FactoryGirl.create(:campaign, :partner => 'default', :price => '35.0')
    FactoryGirl.create(:campaign, :partner => 'sujetdubac', :price => '13.0')
  end

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
    let(:bloomy) do
      { first_name: 'loulou', email: 'loulou@lou.com', age: '44' }
    end
    let(:payload) { { bloomy: bloomy, stripeToken: '1234' } }

    before do
      allow(Mailchimp).to receive(:subscribe_to_journey)
      allow(Mailchimp).to receive(:send_discourse_email)
      allow(Stripe::Charge).to receive(:create)
    end

    describe 'the bloomy creation' do
      subject { Bloomy.first }

      before do
        post :create, payload
      end

      it { expect(subject.first_name).to eq('loulou') }
      it { expect(subject.email).to eq('loulou@lou.com') }
      it { expect(subject.age).to eq(44) }
    end

    describe 'the stripe charges' do
      let(:stripes_args) do
        { amount: amount, currency: 'eur', source: '1234',
          description: '1 Parcours Bloomr',
          receipt_email: 'loulou@lou.com', metadata: metadata }
      end

      after do
        post :create, payload
        expect(response).to redirect_to(payment_thanks_path)
      end

      context 'with no cookie' do
        let(:metadata) do
          { 'info_client' => 'loulou - 44 ans - loulou@lou.com',
            'source' => 'default'}
        end
        let(:amount) { 3500 }

        it 'charges the right amount and redirect to payment_thanks' do
          expect(Stripe::Charge).to receive(:create).with(stripes_args)
        end
      end

      context 'with sujetdubac cookie' do
        let(:metadata) do
          { 'info_client' => 'loulou - 44 ans - loulou@lou.com',
            'source' => 'sujetdubac' }
        end
        let(:amount) { 1300 }

        it 'charge the right amount,
            set the right source and redirect to payment_thanks' do
          request.cookies[:partner] = 'sujetdubac'
          expect(Stripe::Charge).to receive(:create).with(stripes_args)
        end
      end
    end

    describe 'the journey inscription' do
      after { post :create, payload }
      context 'when the cookie is set' do
        before { request.cookies[:auto] = true }
        it 'subscribes to the journey' do
          expect(Mailchimp).to receive(:subscribe_to_journey).once
          expect(Mailchimp).to receive(:send_discourse_email).once
        end
      end
      context 'when the cookie is not set' do
        it 'does not subscribe to the journey' do
          expect(Mailchimp).to receive(:subscribe_to_journey).exactly(0).times
          expect(Mailchimp).to receive(:send_discourse_email).exactly(0).times
        end
      end
    end
  end
end
