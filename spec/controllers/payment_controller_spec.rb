require 'rails_helper'
require 'stripe_mock'

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

  describe 'POST #thanks' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before do
      StripeMock.start
      Stripe.api_key = 'blablabla'
      post :create, { first_name: 'loulou', email: 'loulou@lou.com', age: '44', stripeToken: stripe_helper.generate_card_token }
    end
    after { StripeMock.stop }

    it 'redirect to payment_thanks' do
      expect(response).to redirect_to(payment_thanks_path)
    end

  end

end
