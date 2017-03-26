require 'rails_helper'

RSpec.describe Campaign, type: :model do
  describe 'amount' do
    let!(:default_campagn) { Campaign.create(standard_price: 1, premium_price: 2, partner: 'default') }
    context 'when the prices are not nill' do
      let(:campaign) { Campaign.create(standard_price: 10, premium_price: 20) }

      it 'returns the value' do
        expect(campaign.amount('standard')).to eq(1000)
        expect(campaign.amount('premium')).to  eq(2000)
      end

      it 'returns a Fixnum' do
        expect(campaign.amount('standard').is_a? Fixnum).to be(true)
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
