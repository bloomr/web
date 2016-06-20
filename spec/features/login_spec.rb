require 'rails_helper'

feature 'Login' do
  scenario 'when i log in' do
    user = FactoryGirl.create(:user, password: 'loulou12')

    visit '/users/sign_in'

    within('#new_user') do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'loulou12'
    end

    click_button 'Go Go Go !'
    expect(current_path).to eq('/me/whatsnew')
  end
end
