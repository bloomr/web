require 'rails_helper'

feature 'Buy a journey' do
  let!(:std_pt) { ProgramTemplate.create(name: 'standard', intercom: false, discourse: true) }
  let!(:premium_pt) { ProgramTemplate.create(name: 'premium', intercom: true, discourse: true) }

  let!(:std_bundle) { Bundle.create(name: 'standard', program_templates: [std_pt]) }
  let!(:premium_bundle) { Bundle.create(name: 'premium', program_templates: [premium_pt]) }

  let!(:default_campaign) { FactoryGirl.create(:campaign, partner: 'default') }
  let!(:sujetdubac_campaign) { FactoryGirl.create(:campaign, partner: 'sujetdubac') }

  before do
    default_campaign.bundles_campaigns << BundlesCampaign.new(bundle: std_bundle, price: 35)
    default_campaign.bundles_campaigns << BundlesCampaign.new(bundle: premium_bundle, price: 70)

    sujetdubac_campaign.bundles_campaigns << BundlesCampaign.new(bundle: std_bundle, price: 13)
    sujetdubac_campaign.bundles_campaigns << BundlesCampaign.new(bundle: premium_bundle, price: 26)
  end

  scenario 'I buy a standard program for the first time' do
    email = 'test@test.com'
    visit 'payment'

    fill_email_page(email)

    expect(page).to have_current_path(payment_identity_path(email: email, program_name: 'standard'))

    fill_identity_page

    expect(page).to have_current_path(payment_card_path(bloomy_id: Bloomy.find_by(email: email).id, program_name: 'standard'))
    check_price('35.00')
  end

  scenario 'I buy a premium program after a standard' do
    bloomy = create(:bloomy)
    bloomy.programs << std_pt.to_program

    visit 'payment/premium'
    fill_email_page(bloomy.email)

    expect(page).to have_current_path(payment_card_path(bloomy_id: bloomy.id, program_name: 'premium'))
    check_price('70.00')
  end

  scenario 'I buy a standard program with a reduction' do
    visit '/partner/sujetdubac'
    visit 'payment/premium'
    fill_email_page('test@test.com')
    fill_identity_page
    check_price('26.00')
  end

  def fill_email_page(email)
    fill_in 'bloomy_email', with: email
    click_button 'Suivant'
  end

  def fill_identity_page
    fill_in 'bloomy_first_name', with: 'first_name'
    fill_in 'bloomy_name', with: 'name'
    fill_in 'bloomy_age', with: 34
    fill_in 'bloomy_password', with: 'hphphpasdanjk'
    click_button 'Suivant'
  end

  def check_price(price)
    expect(page).to have_button("Payer #{price} €")
    expect(page).to have_css("a[href=\"https://paypal.me/bloomr/#{price}\"]")
  end
end
