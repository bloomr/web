require 'rails_helper'

def test_post
  scenario 'when a bloomy sign up' do
    expect(Journey).to receive(:new)
    visit '/bred/program?s=tel'

    within(target_selector) do
      fill_in 'bloomy[first_name]', with: 'toto'
      fill_in 'bloomy[email]', with: 'toto@loulou.com'
      fill_in 'bloomy[age]', with: '42'
      check 'cgu'
      click_button 'Inscription'
    end

    expect(current_path).to eq('/bred/program/thanks')

    expect(new_bloomy.first_name).to eq('toto')
    expect(new_bloomy.age).to eq(42)
    expect(new_bloomy.source).to eq('bred - tel')
  end
end

feature 'Bred program' do
  let(:new_bloomy) { Bloomy.find_by email: 'toto@loulou.com' }
  context 'on a phone' do
    let(:target_selector) { '#new_bloomy.show-phone' }

    test_post
  end

  context 'on a desktop' do
    let(:target_selector) { '#new_bloomy.hide-phone' }

    test_post
  end
end
