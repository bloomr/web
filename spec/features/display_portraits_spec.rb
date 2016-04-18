require 'rails_helper'

feature 'List of portraits' do

  scenario 'Displaying the list of portraits' do
     (1..2).each { |i| FactoryGirl.create(:user_published_with_questions, email: "#{i}@a.com") }
     (3..4).each { |i| FactoryGirl.create(:user, email: "#{i}@a.com") }

    visit '/tribes'

    expect(page).to have_content('les bloomeurs')
    expect(page).to have_selector('#portraits_list > li', count: 3)
  end
end
