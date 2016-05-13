require 'rails_helper'

feature 'Buy a journey' do

  scenario 'Usually, I pay the full price' do

    visit '/payment'
    expect(page).not_to have_button('Régler mes 9.90€')
  end

  scenario 'I get a discount if I come from a partner' do

    visit '/partner/sujetdubac'
    visit '/payment'
    expect(page).to have_button('Régler mes 9.90€')
  end
end

