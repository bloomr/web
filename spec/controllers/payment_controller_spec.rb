require 'rails_helper'

RSpec.describe PaymentController, type: :controller do
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
      allow(HTTParty).to receive(:post)
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

      context 'with no cookie' do
        let(:metadata) do
          { 'info_client' => 'loulou - 44 ans - loulou@lou.com' }
        end
        let(:amount) { 3500 }

        it 'charges the right amount and redirect to payment_thanks' do
          expect(Stripe::Charge).to receive(:create).with(stripes_args)
          post :create, payload
          expect(response).to redirect_to(payment_thanks_path)
        end
      end

      context 'with sujetdubac cookie' do
        let(:metadata) do
          { 'info_client' => 'loulou - 44 ans - loulou@lou.com',
            'source' => 'sujetdubac' }
        end
        let(:amount) { 990 }

        it 'charge the right amount,
            set the right source and redirect to payment_thanks' do
          request.cookies[:sujetdubac] = true
          expect(Stripe::Charge).to receive(:create).with(stripes_args)
          post :create, payload
          expect(response).to redirect_to(payment_thanks_path)
        end
      end
    end

    describe 'the mailchimp inscription' do
      let(:url) { 'https://us9.api.mailchimp.com/3.0/lists/9ec70e12ca/members' }

      let(:headers) do
        { 'Authorization' => 'apikey api',
          'Content-Type' => 'application/json' }
      end

      let(:body) do
        { 'status' => 'subscribed', 'email_address' => 'loulou@lou.com',
          'merge_fields' => { 'FNAME' => 'loulou', 'MMERGE3' => 44 } }.to_json
      end

      let(:post_body) { { headers: headers, body: body } }

      before do
        ENV['MAILCHIMP_API_KEY'] = 'api'
      end

      context 'when mailchimp option is activated' do
        before :each do
          ENV['MAILCHIMP_ACTIVATED'] = 'true'
        end

        it 'calls the mailchimp api' do
          expect(HTTParty).to receive(:post).with(url, post_body)
          post :create, payload
        end
      end

      context 'when mailchimp option is not activated' do
        before :each do
          ENV['MAILCHIMP_ACTIVATED'] = nil
        end

        it 'calls the mailchimp api' do
          expect(HTTParty).to receive(:post).with(any_args).exactly(0).times
          post :create, payload
        end
      end
    end
  end
end
