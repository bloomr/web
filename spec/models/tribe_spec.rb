require 'rails_helper'

RSpec.describe Tribe, :type => :model do
  describe '#before save, store the normalize name' do
    context 'when a new tribe is created' do
      let!(:tribe) { Tribe.create( name: '3.0') }
      it 'normalize name is saved' do
        expect(tribe.normalized_name).to eq('3_0')
      end
    end
  end

  describe '#last_month_view_count' do
    context 'when a user with 1 view last month is in the tribe' do
      let(:tribe) { Tribe.create( name: '3.0') }
      before do
        impressions = []
        impressions << Impression.new(created_at: Date.today.beginning_of_month.last_month, request_hash: 'yop')
        impressions << Impression.new(created_at: Date.today.beginning_of_month.last_month - 1, request_hash: 'tip')
        create(:user, impressions: impressions, tribes: [tribe])
      end

      it 'returns one view' do
        expect(tribe.last_month_view_count).to eq(1)
      end

      context 'with another user with 1 view last month in the tribe' do
        before do
          impressions = []
          impressions << Impression.new(created_at: Date.today.beginning_of_month.last_month, request_hash: 'yop')
          create(:user, impressions: impressions, tribes: [tribe])
        end

        it 'returns the 2 views' do
          expect(tribe.last_month_view_count).to eq(2)
        end
      end

      context 'with an user with 1 view last month not in the tribe' do
        before do
          impressions = []
          impressions << Impression.new(created_at: Date.today.beginning_of_month.last_month, request_hash: 'yop')
          create(:user, impressions: impressions)
        end

        it 'returns one view' do
          expect(tribe.last_month_view_count).to eq(1)
        end
      end
    end
  end
end
