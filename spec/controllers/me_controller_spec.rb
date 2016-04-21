require 'rails_helper'

RSpec.describe MeController, :type => :controller do

  context 'when a logged user' do

    let(:user) { create(:user_with_questions) }
    let!(:challenge1) { Challenge.create(name: 'the tribes') }

    before { sign_in(:user, user) }

    describe 'does the challenge1' do

      context 'accepts its default tribes' do
        before do
          post :challenge_1
          user.reload
        end

        it 'adds the challenge 1 to the current user' do
          expect(user.challenges).to match_array(challenge1)
        end
      end

      context 'changes its tribes' do

        let(:tribe) { Tribe.create(name: 'my tribe') }

        before do
          post :challenge_1, user: { tribe_ids: [ tribe.id ] }
          user.reload
        end

        it 'adds the challenge 1 to the current user' do
          expect(user.challenges).to match_array(challenge1)
        end

        it 'puts the right tribes' do
          expect(user.tribes).to match_array(tribe)
        end
      end

    end

    describe 'change it s profile' do

      before do
        put :update, user: payload
        user.reload
      end

      describe 'with a new email' do

        let(:payload) { { email: 'loulou@loulou.com' } }

        it 'saves the new email' do
          expect(user.email).to eq('loulou@loulou.com')
        end
      end

      describe 'with a modified answer' do

        let(:question_id) { user.questions.first.id }
        let(:payload) { { questions_attributes: { id: question_id, answer: 'awesome answer' } } }

        it 'saves the new answer' do
          expect(user.questions.first.answer).to eq('awesome answer')
        end
      end

      describe 'with a new job title' do
        let(:payload) { { job_title: 'crazy_musician' } }

        it 'saves the new job_title' do
          expect(user.job_title).to eq('crazy_musician')
        end
      end

      describe 'with a new tribe' do
        let(:tribe) { Tribe.create(name: 'my tribe') }
        let(:payload) { { tribe_ids: [ tribe.id ] } }

        it 'saves the new tribe' do
          expect(user.tribes.first).to eq(tribe)
        end
      end
    end

  end

end
