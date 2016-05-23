require 'rails_helper'

RSpec.describe PartnerController, type: :controller do

  campaign = FactoryGirl.create(:campaign, :partner => 'default', :price => '35.0')
  campaign = FactoryGirl.create(:campaign, :partner => 'sujetdubac', :price => '13.0', :campaign_url => 'http://bac.bloomr.org/')

  describe 'GET #set_campaign/sujetdubac' do
    before do
      get :set_campaign, :name => 'sujetdubac'
    end

    it 'redirect to bac bloomr org' do
      expect(response).to redirect_to('http://bac.bloomr.org/')
    end

    it 'set the sujetdubac cookie' do
      expect(response.cookies['partner']).to eq('sujetdubac')
    end
  end

end
