require 'rails_helper'

feature 'Login' do
  scenario 'when a user log in' do
    user = FactoryGirl.create(:user, password: 'loulou12')

    visit '/users/sign_in'

    within('#new_user') do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'loulou12'
    end

    click_button 'Go Go Go !'
    expect(current_path).to eq('/me')
  end

  scenario 'when an admin log in' do
    admin = AdminUser.create!(email: 'loulou@loulou.com', password: 'loulou12')

    visit '/admin/login'

    within('#session_new') do
      fill_in 'admin_user[email]', with: admin.email
      fill_in 'admin_user[password]', with: 'loulou12'
    end

    click_button 'Se connecter'
    expect(current_path).to eq('/admin')
  end
end
