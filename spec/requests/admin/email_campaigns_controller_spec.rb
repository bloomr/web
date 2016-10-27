require 'rails_helper'

RSpec.describe Admin::EmailCampaignsController, type: :request do
  include Warden::Test::Helpers

  let(:admin_user) do
    AdminUser.create!(email: 'loulou@loulou.com', password: 'superloulou')
  end

  subject { response }

  context 'when the user is not logged in' do
    describe 'get campagains' do
      before :each do
        get '/admin/email_campaigns'
      end

      it { is_expected.to have_http_status(:redirect) }
    end
  end

  context 'when the user is logged in' do
    describe 'get campagains' do
      before :each do
        Warden.test_mode!
        login_as(admin_user, scope: :admin_user)
        get '/admin/email_campaigns'
      end

      it { is_expected.to have_http_status(:success) }
    end
  end
end
