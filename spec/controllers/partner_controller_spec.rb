require 'rails_helper'

RSpec.describe PartnerController, type: :controller do
  describe 'GET #set_campaign/sujetdubac' do
    context 'when there are 2 campaigns' do
      let!(:default) { FactoryGirl.create(:campaign, partner: 'default', standard_price: '35.0') }
      let!(:sujetdubac) { FactoryGirl.create(:campaign, partner: 'sujetdubac', standard_price: '13.0', campaign_url: 'http://bac.bloomr.org/') }

      describe 'with a partner campaign' do
        before do
          get :set_campaign, name: 'sujetdubac'
        end

        it 'redirect to bac bloomr org' do
          expect(response).to redirect_to('http://bac.bloomr.org/')
        end

        it 'set the sujetdubac cookie' do
          expect(response.cookies['partner']).to eq('sujetdubac')
        end
      end

      describe 'with no partner campaign' do
        before do
          get :set_campaign
        end

        it 'redirect to bac bloomr org' do
          expect(response).to redirect_to('http://test.host/')
        end

        it 'set the sujetdubac cookie' do
          expect(response.cookies['partner']).to eq(nil)
        end
      end
    end
  end
end
