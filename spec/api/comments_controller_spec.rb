require 'rails_helper'

RSpec.describe Api::V1::CommentsController, :type => :request do

  describe "When there is a user and a question" do

    before do
      @payload = {
          comment: {
              author_avatar_url: "http://www.example.org/images/avatar.png",
              author_name: "John Doe",
              comment: "Very interesting question, bro."
          }
      }

      @user = User.create!(
          :email => "yopyop@yop.com",
          :first_name => "John",
          :job_title => "Developer",
          :password => "abcdfedv",
          :published => true)

      @question = Question.create!(
          :title => "My title",
          :answer => "My answer",
          :user_id => User.first.id
      )
    end

    describe "POST #comments with invalid data" do

      it "responds with 400 if empty comment" do
        @payload[:comment][:comment] = ""
        post "api/v1/questions/1/comments", @payload, { "Accept" => "application/json" }
        expect(response).to have_http_status(400)
      end

      it "responds with 400 if nil comment" do
        @payload[:comment][:comment] = nil
        post "api/v1/questions/1/comments", @payload, { "Accept" => "application/json" }
        expect(response).to have_http_status(400)
      end

      it "responds with 400 if empty author's name" do
        @payload[:comment][:author_name] = ""
        post "api/v1/questions/1/comments", @payload, { "Accept" => "application/json" }
        expect(response).to have_http_status(400)
      end

      it "responds with 400 if nil author's name" do
        @payload[:comment][:author_name] = nil
        post "api/v1/questions/1/comments", @payload, { "Accept" => "application/json" }
        expect(response).to have_http_status(400)
      end

      it "strips HTML tags if h4x00rz" do
        @payload[:comment][:comment] = "<script>alert('coucou')</script>"
        post "api/v1/questions/1/comments", @payload, { "Accept" => "application/json" }
        expect(QuestionComment.first.comment).to_not include('<script>')
      end
    end

    describe "POST #comments with valid data" do
      before do
        post "api/v1/questions/1/comments", @payload, { "Accept" => "application/json" }
      end

      it "responds with 200 code if creation of comment" do
        expect(response).to have_http_status(200)
      end

      it "creates the comment correctly" do
        @question = Question.first
        expect(@question.question_comments.length).to eq(1)
      end
    end
  end

end
