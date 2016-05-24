require 'rails_helper'

feature 'Buy a journey' do

  before do
    FactoryGirl.create(:campaign, :partner => 'default', :price => '35.0')
    FactoryGirl.create(:campaign, :partner => 'sujetdubac', :price => '13.0')
  end

  scenario 'Usually, I pay the full price' do

    visit '/payment'
    expect(page).to have_button('Régler mes 35.00 €')
    expect(page).to have_css('a[href="https://paypal.me/bloomr/35.00"]')
  end

  scenario 'I get a discount if I come from a partner' do

    visit '/partner/sujetdubac'
    visit '/payment'
    expect(page).to have_button('Régler mes 13.00 €')
    expect(page).to have_css('a[href="https://paypal.me/bloomr/13.00"]')
  end
end

