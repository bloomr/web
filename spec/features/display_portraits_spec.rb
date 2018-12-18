require 'rails_helper'

feature 'List of portraits' do
  let!(:user1) { FactoryBot.create(:user_published_with_questions, email: '1@a.com') }

  before do
    FactoryBot.create(:user_published_with_questions, email: '2@a.com')
    (3..4).each { |i| FactoryBot.create(:user, email: "#{i}@a.com") }
  end

  scenario 'Displaying one portrait details' do
    visit "/portraits/#{user1.id}"
  end
end
