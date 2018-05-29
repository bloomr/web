require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'amount' do
    let!(:std_pt) { create(:program_template, name: 'standard') }
    let!(:premium_pt) { create(:program_template, name: 'premium') }

    let!(:std_bundle) { Bundle.create(name: 'standard', program_templates: [std_pt]) }
    let!(:premium_bundle) { Bundle.create(name: 'premium', program_templates: [premium_pt]) }

    let!(:default_campaign) { Campaign.create(partner: 'default') }

    let!(:default_bundle_campaign_std) { BundlesCampaign.create!(campaign: default_campaign, bundle: std_bundle, price: 1) }
    let!(:default_bundle_campaign_premium) { BundlesCampaign.create!(campaign: default_campaign, bundle: premium_bundle, price: 2) }

    before do
      default_campaign.bundles_campaigns << default_bundle_campaign_std
      default_campaign.bundles_campaigns << default_bundle_campaign_premium
    end

    context 'when the prices are not nill' do
      let(:other_campaign) { Campaign.create(standard_price: 10, premium_price: 20) }
      let!(:other_bundle_campaign_std) { BundlesCampaign.create(campaign: other_campaign, bundle: std_bundle, price: 10) }
      let!(:other_bundle_campaign_premium) { BundlesCampaign.create(campaign: other_campaign, bundle: premium_bundle, price: 20) }

      before do
        other_campaign.bundles_campaigns << other_bundle_campaign_std
        other_campaign.bundles_campaigns << other_bundle_campaign_premium
      end

      it 'returns the value' do
        expect(other_campaign.amount('standard')).to eq(1000)
        expect(other_campaign.amount('premium')).to  eq(2000)
      end

      it 'returns a Fixnum' do
        expect(other_campaign.amount('standard').is_a? Fixnum).to be(true)
      end
    end

    context 'when the values are nil' do
      let(:campaign) { Campaign.create }

      it 'returns the default price' do
        expect(campaign.amount('standard')).to eq(100)
        expect(campaign.amount('premium')).to  eq(200)
      end
    end
  end
end
