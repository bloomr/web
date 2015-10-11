require 'rails_helper'

RSpec.describe User, :type => :model do

  def create_fake_user index, published=true
    User.create!(
        :email => "yopyop#{index}@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => published)
  end

  def create_fake_question user, identifier="random"
    Question.create!(
        :title => "Title",
        :answer => "Because...",
        :identifier => identifier,
        :user_id => user.id
    )
  end

  before do
    @yop1 = create_fake_user(1, false)

    @yop2 = create_fake_user(2, true)
    @q21 = create_fake_question(@yop2, "love_job")
    @q22 = create_fake_question(@yop2)

    @yop3 = create_fake_user(3, true)
    @yop3.destroy!

    @yop4 = create_fake_user(4, false)

    @yop5 = create_fake_user(5, true)
    @q51 = create_fake_question(@yop5, "love_job")
    @q52 = create_fake_question(@yop5)

    @yop6 = create_fake_user(6, false)
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

  describe "questions to display" do

    it 'should be published' do
      user = User.new()
      user.questions.push(Question.new({title:'not published', published:false}))
      user.questions.push(Question.new({title:'published', published:true}))

      expect(user.questions_to_display().length).to eq(1)
    end

  end

  describe "find_published_with_love_job_question method" do

    it 'should fetch the `love_job` question for each user' do
      users = User.find_published_with_love_job_question 1
      expect(users.length).to eq 2
      user2 =  users.select { |u| u.email == 'yopyop2@yop.com' }.first
      expect(user2.questions.length).to eq 1
    end
  end

end
