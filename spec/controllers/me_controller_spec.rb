require 'rails_helper'

RSpec.describe MeController, :type => :controller do

  context 'when a user logged' do

    let(:user) { user = create(:user); sign_in(:user, user); user }

    describe 'change its email' do
      before do
        put :update, id: user.id, user: { email: 'loulou@loulou.com' }
      end

      it 'the new email is saved' do
        expect(User.first.email).to eq('loulou@loulou.com')
      end
    end

  end

end
