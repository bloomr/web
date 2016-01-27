require 'rails_helper'

RSpec.describe Impression, type: :model do
  describe '#last_month_count' do

    subject { Impression.last_month_count }

    before do
      allow(Date).to receive(:today).and_return(Date.new(2016, 2, 3))
    end

    let(:begining_of_last_month) { Date.today.beginning_of_month.last_month }

    context 'when there is a view the month before' do
      before do
        Impression.create(created_at: begining_of_last_month.last_month, session_hash: 'a')
      end

      it { is_expected.to eq(0) }
    end

    context 'when there are 2 views last month' do
      before do
        Impression.create(created_at: begining_of_last_month, session_hash: 'a')
        Impression.create(created_at: begining_of_last_month, session_hash: 'b')
      end

      it { is_expected.to eq(2) }
    end

    context 'when there are 2 views last month with the same session' do
      before do
        Impression.create(created_at: begining_of_last_month, session_hash: 'a')
        Impression.create(created_at: begining_of_last_month, session_hash: 'a')
      end

      it { is_expected.to eq(1) }
    end

    context 'when there is a view this month' do
      before do
        Impression.create(created_at: Date.today, session_hash: 'a')
      end

      it { is_expected.to eq(0) }
    end
  end

end
