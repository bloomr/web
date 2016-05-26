require 'rails_helper'
require 'erb'
include ERB::Util

feature 'Discourse sso' do
  before :each do
    ENV['DISCOURSE_URL'] = 'http://test.com'
    ENV['DISCOURSE_SECRET'] = 'd836444a9e4084d5b224a60c208dce14'
  end

  scenario 'bad password route to the same page' do
    user = Bloomy.create(email: 'bloomy@gmail.com', password: 'loulou12')
    nonce = 'cb68251eefb5211e58c00ff1395f0c0b'
    sso = Base64.encode64("nonce=#{nonce}")
    sso_encode = url_encode(sso)
    sig = OpenSSL::HMAC.hexdigest('sha256', ENV['DISCOURSE_SECRET'], sso)
    visit "/sso?sso=#{sso_encode}&sig=#{sig}"
    fill_in('bloomy_email', with: user.email)
    fill_in('bloomy_password', with: 'wrong')
    find('input[name="commit"]').click
    expect(page.current_path).to eq('/sso')
  end
end
