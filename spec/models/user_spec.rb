require 'rails_helper'

RSpec.describe User, :type => :model do

  def create_fake_question options={}
    default = {
        :title => "Title",
        :answer => "Because...",
        :identifier => "random",
        :published => true
    }
    q = Question.create!(default.merge(options))

    options[:user].questions.push(q)
    options[:user].save
  end


  describe "next and previous method" do

    before do
      @yop1 = create(:user, email: "1@a.com", published: false)
      @yop2 = create(:user, email: "2@a.com", published: true)
      @yop3 = create(:user, email: "3@a.com", published: true)
      @yop3.destroy!
      @yop4 = create(:user, email: "4@a.com", published: false)
      @yop5 = create(:user, email: "5@a.com", published: true)
      @yop6 = create(:user, email: "6@a.com", published: false)
    end

    describe "the next method" do

      it 'return the next published user order by id' do
        expect((User.next @yop2.id)).to eq(@yop5)
      end

      it 'return the first published user if the end is reached' do
        expect((User.next @yop5.id)).to eq(@yop2)
      end

    end

    describe "the previous method" do

      it 'return the previous published user order by id' do
        expect((User.previous @yop5.id)).to eq(@yop2)
      end

      it 'return the last user if the start is reached' do
        expect((User.previous @yop1.id)).to eq(@yop5)
      end

    end

  end


  describe "questions to display" do

    before do
      @user = User.new()
      @user.questions.push(Question.new({title:'not published', published:false}))
      @user.questions.push(Question.new({title:'published', published:true}))
    end

    it 'should be published' do
      expect(@user.questions_to_display().length).to eq(1)
    end

  end

  describe "find_published_with_love_job_question method" do

    describe 'with one published user with no love_job question' do
      before do
        @user1 = create(:user)
        create_fake_question(user: @user1)
      end

      it 'should fetch no user' do
        users = User.find_published_with_love_job_question()
        expect(users.length).to eq 0
      end
    end

    describe "with one published user with 2 questions" do
      before do
        @user1 = create(:user)
        create_fake_question(user: @user1, identifier: "love_job")
        create_fake_question(user: @user1)
      end

      it 'should fetch the user with the `love_job` question' do
        user = (User.find_published_with_love_job_question()).first
        expect(user.questions.length).to eq 1
        expect(user.questions[0].identifier).to eq "love_job"
      end
    end

    describe "with 3 published users with different number of questions" do
      before do
        @user1 = create(:user, email: "1@a.com")
        create_fake_question(user: @user1, identifier: "love_job")

        @user2 = create(:user, email: "2@a.com")
        create_fake_question(user: @user2, identifier: "love_job")
        create_fake_question(user: @user2, identifier: "random2")
        create_fake_question(user: @user2)

        @user3 = create(:user, email: "3@a.com")
        create_fake_question(user: @user3, identifier: "love_job")
        create_fake_question(user: @user3)
      end

      it 'should order the users by their number of question' do
        users = User.find_published_with_love_job_question()
        expect(users.map{|u| u.email}).to eq %w{2@a.com 3@a.com 1@a.com}
      end
    end

    describe "with 3 published users" do
      before do
        (1..3).each do |i|
          user = create(:user, email: "#{i}@a.com")
          create_fake_question(user: user, identifier: "love_job")
        end
      end

      describe "when a first page of 2 is asked" do
        before do
          @users = User.find_published_with_love_job_question(nb_per_page: 2)
        end

        it 'should return only the 2 first users order by their id' do
          expect(@users.map{|u| u.email}).to eq %w{3@a.com 2@a.com}
        end
      end

      describe "when the second page of 2 is asked" do
        before do
          @users = User.find_published_with_love_job_question(nb_per_page: 2, page: 1)
        end

        it 'should return only the 3rd user' do
          expect(@users.map{|u| u.email}).to eq %w{1@a.com}
        end
      end
    end

    describe "with 1 unpublished user" do
      before do
        user = create(:user, published: false)
        create_fake_question(user: user, identifier: "love_job")
        @users = User.find_published_with_love_job_question()
      end

      it "should return no user" do
        expect(@users.length).to eq(0)
      end
    end

    describe "with 1 published user with 1 published and 1 not published questions" do
      before do
        user = create(:user, email: "1@a.com")
        create_fake_question(user: user, identifier: "love_job")
        create_fake_question(user: user, identifier: "plop", published: false)
      end

      describe "with another published user with 2 published questions" do
        before do
          user = create(:user, email: "2@a.com")
          create_fake_question(user: user, identifier: "love_job")
          create_fake_question(user: user, identifier: "plop")
          @users = User.find_published_with_love_job_question()
        end

        it "should return the one with the 2 published questions first" do
          expect(@users.map{|u| u.email}).to eq(["2@a.com", "1@a.com"])
        end

      end
    end

  end
end
