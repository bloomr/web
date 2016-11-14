require 'rails_helper'

RSpec.describe Stat, type: :model do
  describe 'the engagement_rate' do
    subject { Stat.engagement_rate }

    context 'with no user' do
      it { is_expected.to eq(0) }

      context 'and one challenge' do
        let!(:challenge) { Challenge.create!(name: 'c1') }
        it { is_expected.to eq(0) }
      end
    end

    context 'whith one user' do
      let!(:user) { create(:user) }
      it { is_expected.to eq(0) }

      context 'when there is one challenge' do
        let!(:challenge) { Challenge.create!(name: 'c1') }

        context 'and the user has complete the challenge' do
          before :each do
            user.challenges << challenge
            user.save
          end

          it { is_expected.to eq(100) }
        end
      end
    end

    context 'whith 3 user' do
      let!(:users) { (1..3).map { create(:user) } }

      context 'with 2 challenges' do
        let!(:challenges) do
          [Challenge.create!(name: 'c1'), Challenge.create!(name: 'c2')]
        end

        context 'and one user has complete all the challenge' do
          before :each do
            users[0].challenges += challenges
            users[0].save
          end

          it { is_expected.to eq(33) }
        end
      end
    end
  end
end
