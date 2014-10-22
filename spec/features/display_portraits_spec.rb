feature "List of portraits" do

  scenario "Displaying the list of portraits" do
    visit "/portraits" do
      user1 = User.create(
          :email => "john.doe@example.org",
          :first_name => "John",
          :job_title => "Developer")
      user2 = User.create(
          :email => "jane.doe@example.org",
          :first_name => "Jane",
          :job_title => "Architect")
      user_unemployed = User.create(
          :email => "mike.test@example.org",
          :first_name => "Mike"
      )
      expect(page).to have_content('Portraits')
      expect(page).to have_selector('#portraits_list .portrait-item', :count => 2)
    end
  end
end