require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'amount' do
    let!(:std_pt) { create(:program_template, name: 'standard') }
    let!(:premium_pt) { create(:program_template, name: 'premium') }

    let!(:default_campaign) { Campaign.create(partner: 'default') }
    let!(:default_campaign_program_std) { CampaignsProgramTemplate.create!(campaign: default_campaign, program_template: std_pt, price: 1) }
    let!(:default_campaign_program_premium) { CampaignsProgramTemplate.create!(campaign: default_campaign, program_template: premium_pt, price: 2) }

    before do
      default_campaign.campaignsProgramTemplates << default_campaign_program_std
      default_campaign.campaignsProgramTemplates << default_campaign_program_premium
    end

    context 'when the prices are not nill' do
      let(:other_campaign) { Campaign.create(standard_price: 10, premium_price: 20) }
      let!(:other_campaign_program_std) { CampaignsProgramTemplate.create(campaign: other_campaign, program_template: std_pt, price: 10) }
      let!(:other_campaign_program_premium) { CampaignsProgramTemplate.create(campaign: other_campaign, program_template: premium_pt, price: 20) }

      before do
        other_campaign.campaignsProgramTemplates << other_campaign_program_std
        other_campaign.campaignsProgramTemplates << other_campaign_program_premium
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
