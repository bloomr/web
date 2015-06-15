require 'rails_helper'

RSpec.describe User, :type => :model do

  before do
    @yop1 = User.create!(
        :email => "yopyop1@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => false)

    @yop2 = User.create!(
        :email => "yopyop2@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => true)

    @yop3 = User.create!(
        :email => "yopyop3@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => true)

    @yop4 = User.create!(
        :email => "yopyop4@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => false)

    @yop5 = User.create!(
        :email => "yopyop5@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => true)

    @yop6 = User.create!(
        :email => "yopyop6@yop.com",
        :first_name => "John",
        :job_title => "Developer",
        :password => "abcdfedv",
        :published => false)


    @yop3.destroy!

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

end
