require 'rails_helper'

RSpec.describe User, :type => :model do

  describe 'next and previous method' do

    before do
      @yop1 = create(:user, published: false)
      @yop2 = create(:user)
      @yop3 = create(:user, published: false)
      @yop4 = create(:user)
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

  describe 'find_published_with_love_job_question method' do

    let(:result) { User.find_published_with_love_job_question() }

    describe 'with one published user with no love_job question' do

      let!(:user) { create(:user_with_questions, question_love_job: false) }

      it 'should fetch no user' do
        expect(result.length).to eq 0
      end
    end

    describe 'with one published user with questions' do

      let!(:user_with_questions) { create(:user_with_questions) }

      it 'should fetch the user with the `love_job` question' do
        expect(result.first.questions.length).to eq 1
        expect(result.first.questions[0].identifier).to eq 'love_job'
      end
    end

    describe 'with 3 published users with different number of questions' do
      before do
        create(:user_with_questions, email: '1@a.com', questions_count: 1)
        create(:user_with_questions, email: '2@a.com', questions_count: 3)
        create(:user_with_questions, email: '3@a.com', questions_count: 2)
      end

      it 'should order the users by their number of question' do
        expect(result.map(&:email)).to eq %w{2@a.com 3@a.com 1@a.com}
      end
    end

    describe 'with 3 published users' do

      let!(:with_3_users) { (1..3).each { |i| create(:user_with_questions, email: "#{i}@a.com") } }

      describe 'when a first page of 2 is asked' do
        let(:result) { User.find_published_with_love_job_question(nb_per_page: 2) }

        it 'should return only the 2 first users order by their id' do
          expect(result.map(&:email)).to eq %w{3@a.com 2@a.com}
        end
      end

      describe 'when the second page of 2 is asked' do
        let(:result) { User.find_published_with_love_job_question(nb_per_page: 2, page: 1) }

        it 'should return only the 3rd user' do
          expect(result.map(&:email)).to eq %w{1@a.com}
        end
      end
    end

    describe 'with 1 unpublished user' do
      let!(:unpublished_user) { create(:user_with_questions, published: false) }

      it 'should return no user' do
        expect(result.length).to eq(0)
      end
    end

    describe 'with 1 published user with 1 published and 1 not published questions' do
      before do
        user = create(:user_with_questions, email: '1@a.com')
        user.questions << create(:question, published: false)
        user.save
      end

      describe 'with another published user with 2 published questions' do
        before do
        user = create(:user_with_questions, email: '2@a.com')
        user.questions << create(:question)
        user.save
        end

        it 'should return the one with the 2 published questions first' do
          expect(result.map(&:email)).to eq(['2@a.com', '1@a.com'])
        end

      end
    end

  end

  describe '.last_month_view_count' do
    let(:user) { create(:user) }
    let!(:impression) do
      user.impressions << Impression.new(created_at: Date.today.beginning_of_month.last_month, request_hash: 'yop')
    end

    it 'count the number of view of last month' do
      expect(user.last_month_view_count).to eq(1)
    end
  end

  describe '.default_tribe' do
    subject { user.default_tribe }

    context 'and a user with no keyword' do
      let(:user) { create(:user) }
      it { is_expected.to eq(nil) }
    end

    context 'with an user with a keyword not linked to any tribe' do
      let(:lonely_keyword) { Keyword.create() }
      let(:user) { create(:user, keywords: [lonely_keyword]) }
      it { is_expected.to eq(nil) }
    end

    context 'with a "world" tribe linked to "ecologie" keyword' do
      let!(:world_tribe) { Tribe.create(name: 'save the world') }
      let(:ecologie_keyword) { Keyword.create(tribe: world_tribe) }

      context 'and a user with ecologie keyword' do
        let(:user) { create(:user, keywords: [ecologie_keyword]) }
        it { is_expected.to eq(world_tribe) }
      end

      context 'with a "beautiful" tribe linked to "artisanat" and "flowers" keyword' do
        let(:beautiful_tribe) { Tribe.create(name: 'beautiful') }
        let(:artisanat_keyword) { Keyword.create(tribe: beautiful_tribe) }
        let(:flowers_keyword) { Keyword.create(tribe: beautiful_tribe) }

        context 'and a user with the 3 keywords' do
          let(:user) { create(:user, keywords: [ecologie_keyword, artisanat_keyword, flowers_keyword]) }
          it { is_expected.to eq(beautiful_tribe) }
        end
      end
    end
  end

end
