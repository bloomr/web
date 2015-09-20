feature "List of portraits" do

  scenario "Displaying the list of portraits" do

    user1 = User.create!(
        :email => "john.doe@example.org",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => true)

    q11 = Question.create!(
        :title => "Love Job Title",
        :answer => "Because...",
        :identifier => "love_job",
        :user_id => user1.id
    )

    user2 = User.create!(
        :email => "jane.doe@example.org",
        :first_name => "Jane",
        :job_title => "Architect",
        :password => "abcdfedv",
        :published => true)

    q21 = Question.create!(
        :title => "Love Job Title",
        :answer => "Because...",
        :identifier => "love_job",
        :user_id => user2.id
    )

    user_not_published = User.create!(
        :email => "mike.test@example.org",
        :first_name => "Mike",
        :password => "abcdfedv",
        :job_title => "Architect")

    q31 = Question.create!(
        :title => "Love Job Title",
        :answer => "Because...",
        :identifier => "love_job",
        :user_id => user_not_published.id
    )

    visit "/portraits"

    expect(page).to have_content("Quel métier choisir")
    expect(page).to have_selector('#portraits_list > li', :count => 2)

  end
end