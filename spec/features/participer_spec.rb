feature "Enrolling" do

  scenario "I can enroll" do

    visit "/participer"

    expect(page).to have_text("Votre email")
    fill_in :email, :with => "loulou@yop.com"
    fill_in 'Votre métier', :with => "jardinier"
    fill_in 'Votre prénom', :with => "loulou"
    fill_in "Au fond, qu'est ce qui fait que vous aimez votre métier ?", :with => "j aime les arbres"
    fill_in "Que faites vous exactement ?", :with => "je plante des pommiers"
    fill_in "5 mots-clés associés à votre métier, séparés par une virgule", :with => "1, 2, 3, 4, 5"

    click_button "Enregistrer"

    expect(page).to have_text("Merci beaucoup !")

    expect(User.count).to eq(1)
    loulou = User.first
    expect(loulou.email).to eq("loulou@yop.com")
    expect(loulou.job_title).to eq("jardinier")
    expect(loulou.first_name).to eq("loulou")
    expect(loulou.questions.count).to eq(2)
    expect(loulou.questions[0].answer).to eq("j aime les arbres")
    expect(loulou.questions[1].answer).to eq("je plante des pommiers")
    expect(loulou.keyword_list).to eq(["1", "2", "3", "4", "5"])
    expect(loulou.published).to eq(false)

  end

  scenario "my form is already filled" do

    email = "un Truc chélou !# @op"
    metier = "Ingénieur RD Bling $ ..\/,<>{}~" # & do not work

    visit "/participer?email="+ URI::encode(email) + "&metier=" + URI::encode(metier)

    expect(find_field(:email).value).to eq(email)
    expect(find_field('Votre métier').value).to eq(metier)
  end
end