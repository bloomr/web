require 'rails_helper'

RSpec.describe MeController, :type => :controller do

  context 'when a logged user' do

    let(:user) { create(:user_with_questions) }

    before { sign_in(:user, user) }

    describe 'change it s profile' do

      before do
        put :update, id: user.id, user: payload
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
