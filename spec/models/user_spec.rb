require 'rails_helper'

RSpec.describe User, :type => :model do

  describe 'next and previous method' do

    before do
      @yop1 = create(:user, published: false)
      @yop2 = create(:user_published_with_questions)
      @yop3 = create(:user, published: false)
      @yop4 = create(:user_published_with_questions)
      @yop5 = create(:user, published: false)
    end

    describe 'the next method' do

      it 'return the next published user order by id' do
        expect(User.next(@yop2.id)).to eq(@yop4)
      end

      it 'return the first published user if the end is reached' do
        expect(User.next(@yop4.id)).to eq(@yop2)
      end

    end

    describe 'the previous method' do

      it 'return the previous published user order by id' do
        expect(User.previous(@yop4.id)).to eq(@yop2)
      end

      it 'return the last user if the start is reached' do
        expect(User.previous(@yop1.id)).to eq(@yop4)
      end

    end

  end


  describe 'questions to display' do

    before do
      @user = create(:user)
      @user.questions << Question.new(title: 'not published', published: false)
      @user.questions << Question.new(title: 'published', published: true)
    end

    it 'should be published' do
      expect(@user.questions_to_display().length).to eq(1)
    end

  end

  describe 'before_save' do
    context 'when a user has not a love_job published question' do
      let(:user) { user = create(:user, published: true); user.reload }
      it 'unpublishes the user' do
        expect(user.published).to eq(false)
      end
    end

    context 'when a user has a love_job published question' do
      let(:user) { user = create(:user_published_with_questions); user.reload }
      it 'keeps the published state of the user' do
        expect(user.published).to eq(true)
      end
    end

  end
  describe '.active_ordered' do

    let(:result) { User.active_ordered }

    describe 'with one unpublished user' do

      let!(:user) { create(:user) }

      it 'should fetch no user' do
        expect(result.length).to eq 0
      end
    end

    describe 'with one published user with questions' do

      let!(:user) { create(:user_published_with_questions) }

      it 'should fetch the user' do
        expect(result.length).to eq 1
        expect(result.first.questions.length).to eq(2)
      end
    end

    describe 'with 3 published users with different number of questions' do
      before do
        create(:user_published_with_questions, email: '1@a.com', questions_count: 1)
        create(:user_published_with_questions, email: '2@a.com', questions_count: 3)
        create(:user_published_with_questions, email: '3@a.com', questions_count: 2)
      end

      it 'should order the users by their number of question' do
        expect(result.map(&:email)).to eq %w{2@a.com 3@a.com 1@a.com}
      end
    end

    describe 'with 3 published users' do

      let!(:with_3_users) { (1..3).each { |i| create(:user_published_with_questions, email: "#{i}@a.com") } }

      describe 'when a first page of 2 is asked' do
        let(:result) { User.active_ordered.paged(nb_per_page: 2) }

        it 'should return only the 2 first users order by their id' do
          expect(result.map(&:email)).to eq %w{3@a.com 2@a.com}
        end
      end

      describe 'when the second page of 2 is asked' do
        let(:result) { User.active_ordered.paged(nb_per_page: 2, page: 1) }

        it 'should return only the 3rd user' do
          expect(result.map(&:email)).to eq %w{1@a.com}
        end
      end
    end

    describe 'with 1 published user with 2 published and 2 not published questions' do
      before do
        user = create(:user_published_with_questions, email: '1@a.com')
        user.questions << create(:question, published: false)
        user.questions << create(:question, published: false)
        user.save
      end

      describe 'with another published user with 3 published questions' do
        before do
          user = create(:user_published_with_questions, email: '2@a.com')
          user.questions << create(:question)
          user.save
        end

        it 'should return the one with the 3 published questions first' do
          expect(result.map(&:email)).to eq(['2@a.com', '1@a.com'])
        end

      end
    end

  end

  describe 'find_published_with_tag' do
    subject { User.find_published_with_tag(tag: tag, nb_per_page: nb_per_page, page: page) }
    let(:nb_per_page) { 1 }
    let(:page) { 0 }
    describe 'with one published user with a tag' do

      let!(:user) { create(:user_published_with_questions, keywords: [Keyword.create(tag: 'tag')]) }
      let(:tag) { 'tag' }

      context 'when one asks this tag' do
        let(:page) { 0 }
        it { is_expected.to eq([user]) }
      end

      context 'when one asks a second page' do
        let(:page) { 1 }
        it { is_expected.to be_empty }
      end

    end
  end

  describe '.last_month_view_count' do
    let(:user) { create(:user) }
    let!(:impression) do
      user.impressions << Impression.new(created_at: Date.today.beginning_of_month.last_year, request_hash: 'yip')
      user.impressions << Impression.new(created_at: Date.today.beginning_of_month.last_month, request_hash: 'yop')
      user.impressions << Impression.new(created_at: Date.today, request_hash: 'yup')
    end

    it 'count the number of view of last month' do
      expect(user.last_month_view_count).to eq(1)
    end
  end

  describe '.default_tribes' do
    subject { user.default_tribes }

    context 'and a user with no keyword' do
      let(:user) { create(:user) }
      it { is_expected.to be_empty }
    end

    context 'with an user with a keyword not linked to any tribe' do
      let(:lonely_keyword) { Keyword.create() }
      let(:user) { create(:user, keywords: [lonely_keyword]) }
      it { is_expected.to be_empty }
    end

    context 'with a "world" tribe linked to "ecologie" keyword' do
      let!(:world_tribe) { Tribe.create(name: 'save the world') }
      let(:ecologie_keyword) { Keyword.create(tribe: world_tribe) }

      context 'and a user with ecologie keyword' do
        let(:user) { create(:user, keywords: [ecologie_keyword]) }
        it { is_expected.to match_array([world_tribe]) }
      end

      context 'and two other keywords without tribes' do
        let(:without_tribe_keyword1) { Keyword.create() }
        let(:without_tribe_keyword2) { Keyword.create() }

        context 'and a user with this 3 keywords' do
          let(:user) { create(:user, keywords: [ecologie_keyword, without_tribe_keyword1, without_tribe_keyword2]) }
          it { is_expected.to eq([world_tribe]) }
        end
      end

      context 'with a "beautiful" tribe linked to "artisanat" and "flowers" keyword' do
        let(:beautiful_tribe) { Tribe.create(name: 'beautiful') }
        let(:artisanat_keyword) { Keyword.create(tribe: beautiful_tribe) }
        let(:flowers_keyword) { Keyword.create(tribe: beautiful_tribe) }

        context 'and a user with the 3 keywords' do
          let(:user) { create(:user, keywords: [ecologie_keyword, artisanat_keyword, flowers_keyword]) }
          it { is_expected.to match_array([beautiful_tribe, world_tribe]) }
        end
      end
    end
  end

end
