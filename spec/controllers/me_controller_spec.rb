require 'rails_helper'

RSpec.describe MeController, :type => :controller do

  context 'when a user logged' do

    let(:user) { user = create(:user_with_questions); sign_in(:user, user); user }

    describe 'change its email' do
      before do
        put :update, id: user.id, user: { email: 'loulou@loulou.com' }
      end

      it 'the new email is saved' do
        expect(User.first.email).to eq('loulou@loulou.com')
      end
    end

    describe 'change one answer' do
      before do
        question_id = user.questions.first.id
        put :update, id: user.id, user: { questions_attributes: { id: question_id, answer: 'awesome answer' } }
      end

      it 'the new answer is saved' do
        expect(User.first.questions.first.answer).to eq('awesome answer')
      end
    end

  end

end
