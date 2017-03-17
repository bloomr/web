require 'rails_helper'
require 'erb'
include ERB::Util

feature 'password recovery' do
  before :each do
    ENV['DISCOURSE_URL'] = 'http://test.com'
    ENV['DISCOURSE_SECRET'] = 'd836444a9e4084d5b224a60c208dce14'
  end

  scenario 'a user recover is password' do
    user = FactoryGirl.create(:user, password: 'loulou12')

    visit '/users/sign_in'

    click_on "(Oups ... j'ai oublié mon mot de passe)"
    fill_in 'user[email]', with: user.email
    click_on 'Réinitialiser mon mot de passe'

    mail = ActionMailer::Base.deliveries.last

    recovery_link = %r{"http:\/\/localhost(.*)"}.match(mail.body.to_s)[1]

    visit recovery_link

    within('#new_user') do
      fill_in 'user[password]', with: 'loulou34'
      fill_in 'user[password_confirmation]', with: 'loulou34'
    end

    click_on 'Changer mon mot de passe'

    user.reload
    expect(user.valid_password?('loulou34')).to be(true)
    expect(current_path).to eq('/me')
  end

  scenario 'a bloomy recover is password' do
    bloomy = FactoryGirl.create(:bloomy, password: 'loulou12')

    nonce = 'cb68251eefb5211e58c00ff1395f0c0b'
    sso = Base64.encode64("nonce=#{nonce}")
    sso_encode = url_encode(sso)
    sig = OpenSSL::HMAC.hexdigest('sha256', ENV['DISCOURSE_SECRET'], sso)
    visit "/sso?sso=#{sso_encode}&sig=#{sig}"

    click_on "(Oups ... j'ai oublié mon mot de passe)"
    fill_in 'bloomy[email]', with: bloomy.email
    click_on 'Réinitialiser mon mot de passe'

    mail = ActionMailer::Base.deliveries.last

    recovery_link = %r{"http:\/\/localhost(.*)"}.match(mail.body.to_s)[1]

    visit recovery_link

    within('#new_bloomy') do
      fill_in 'bloomy[password]', with: 'loulou34'
      fill_in 'bloomy[password_confirmation]', with: 'loulou34'
    end

    click_on 'Changer mon mot de passe'

    bloomy.reload
    expect(bloomy.valid_password?('loulou34')).to be(true)
    expect(current_url).to eq('https://programs.bloomr.org/')
  end
end
