require 'rails_helper'

feature 'Buy a journey' do
  before do
    FactoryGirl.create(:campaign, partner: 'default', standard_price: '35.0', premium_price: '70')
    FactoryGirl.create(:campaign, partner: 'sujetdubac', standard_price: '13.0', premium_price: '26')
    Campaign.create(partner: 'no-reduction', campaign_url: 'yop')
  end

  scenario 'I pay standard price with a default url' do
    visit '/payment'
    check_price('35.00')
  end

  scenario 'I pay the standard price with standard url' do
    visit '/payment/standard'
    check_price('35.00')
  end

  scenario 'I pay the premium price with premium url' do
    visit '/payment/premium'
    check_price('70.00')
  end

  scenario 'I ve got a special form if its a gift' do
    visit '/payment?gift=true'
    expect(page).to have_field('buyer_email')
    expect(page.find('#gift', visible: false).value).to eq('true')
  end

  scenario 'i ve got a voucher if its a gift' do
    visit '/payment/thanks?gift=true'
    click_link 'Télécharger le coupon PDF'
  end

  scenario 'I get a discount if I come from a partner' do
    visit '/partner/sujetdubac'

    visit '/payment'
    check_price('13.00')

    visit '/payment/standard'
    check_price('13.00')

    visit '/payment/premium'
    check_price('26.00')
  end

  scenario 'I get a default price if no reduction is set' do
    visit '/partner/no-reduction'

    visit '/payment/standard'
    check_price('35.00')

    visit '/payment/premium'
    check_price('70.00')
  end

  def check_price(price)
    expect(page).to have_button("Payer #{price} €")
    expect(page).to have_css("a[href=\"https://paypal.me/bloomr/#{price}\"]")
  end
end
