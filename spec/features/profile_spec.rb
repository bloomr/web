require 'capybara_helper'

feature 'the private profile' do
  describe 'with some default data', js: true do
    QUESTION_COUNT = 3

    before :each do
      challenge_names = ['the tribes', 'must read', 'interview']
      challenge_names.each { |name| Challenge.create(name: name) }

      ['les ecolos', 'les moustachus'].each { |name| Tribe.create(name: name) }

      (1..QUESTION_COUNT).each do |e|
        Question.create(title: "q#{e}", step: 'first_interview')
      end

      keywords = (1..3).map { |e| Keyword.create(tag: "k#{e}") }
      FactoryGirl.create(:user_published_with_questions, keywords: keywords)
    end

    def test_user
      User.find_by(email: 'test@test.com')
    end

    def with_a_new_user
      visit '/enrollment'
      within('#new_user') do
        fill_in 'user_first_name', with: 'first_name'
        fill_in 'user_email', with: 'test@test.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_job_title', with: 'job'
      end
      click_button 'Go Go Go !'

      find('.greetings', wait: 15)
      wait_for_ajax

      yield
    end

    def add_in_multiple_select(value)
      find('.ember-basic-dropdown-trigger').click
      find('input[type="search"]').set(value)
      find('li.ember-power-select-option[data-option-index="1"]').click
    end

    it 'lets me sign in' do
      with_a_new_user do
        expect(page).to have_content 'Salut First_name'
      end
    end

    # TODO: handle upload file on remote selenium
    unless ENV['TRAVIS']
      it 'lets me complete the interview challenge' do
        with_a_new_user do
          find('.fileinput-button.interview')
          make_input_file_visible = <<-SCRIPT
          window.$('input[type=file]').css('position', 'inherit');
          window.$('input[type=file]').css('opacity', 1);
          SCRIPT
          page.execute_script(make_input_file_visible)
          within('.fileinput-button.interview') do
            attach_file('avatar', Rails.root + 'spec/fixtures/chewbacca.png')
          end

          wait_for_ajax

          click_button 'Continuer', wait: 30
          (1..3).each { |e| add_in_multiple_select("k#{e}") }

          fill_trix_editors = <<-SCRIPT
          trixEditors = document.querySelectorAll('trix-editor');
          trixEditors.forEach(function(element) {
            element.editor.setSelectedRange([0, 0]);
            element.editor.insertString("Hello");
          });
          SCRIPT
          page.execute_script(fill_trix_editors)

          check('doAuthorize')

          click_button 'Terminer'

          wait_for_ajax

          expect(test_user.questions.count).to be(QUESTION_COUNT)
          expect(test_user.questions.all? { |e| e.answer == 'Hello' }).to be(true)
          expect(test_user.do_authorize).to be(true)

          challenge_interview = Challenge.find_by(name: 'interview')
          expect(test_user.challenges.include?(challenge_interview)).to be(true)
        end
      end
    end

    it 'lets me complete the tribe challenge' do
      with_a_new_user do
        find('a[href="/me/challenges?name=tribes"]').click
        find('.ember-basic-dropdown-trigger').click
        find('li.ember-power-select-option', text: 'les ecolos').click
        find('.save').click

        wait_for_ajax

        expect(test_user.tribes).to match([Tribe.find_by(name: 'les ecolos')])

        challenge_tribes = Challenge.find_by(name: 'the tribes')
        expect(test_user.challenges.include?(challenge_tribes)).to be(true)
      end
    end

    it 'lets me complete the book challenge' do
      book = Book.new(title: 'toto', author: 'author', isbn: '123',
                      asin: 'ouaich', image_url: 'missing.png')

      expect(Amazon::Search).to receive(:books).and_return([book])

      with_a_new_user do
        find('a[href="/me/challenges?name=mustread"]').click
        fill_in 'inputSearchText', with: 'toto'
        find('.search').click

        find('.results-books > li:first-child > div').click

        find('.done').click

        wait_for_ajax

        expect(test_user.books[0].title).to eq('toto')
        challenge_must_read = Challenge.find_by(name: 'must read')
        expect(test_user.challenges.include?(challenge_must_read)).to be(true)
      end
    end
  end
end
