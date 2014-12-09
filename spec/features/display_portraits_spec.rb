feature "List of portraits" do

  scenario "Displaying the list of portraits" do

    user1 = User.create!(
        :email => "john.doe@example.org",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => true)
    user2 = User.create!(
        :email => "jane.doe@example.org",
        :first_name => "Jane",
        :job_title => "Architect",
        :password => "abcdfedv",
        :published => true)
    user_not_published = User.create!(
        :email => "mike.test@example.org",
        :first_name => "Mike",
        :password => "abcdfedv",
        :job_title => "Architect")

    visit "/portraits"

    expect(page).to have_content('Galerie')
    expect(page).to have_selector('.portrait-item', :count => 2)

  end
end