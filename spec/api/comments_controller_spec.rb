require 'rails_helper'

RSpec.describe Api::V1::CommentsController, :type => :request do

  describe "When there is a user and a question" do

    before do
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

    describe "POST #comments" do

      before do
        @payload = {
            comment: {
                author_avatar_url: "http://www.example.org/images/avatar.png",
                author_name: "John Doe",
                comment: "Very interesting question, bro."
            }
        }
      end

      describe "with invalid data" do

        it "responds with 400 if empty comment" do
          @payload[:comment][:comment] = ""
          post "/api/v1/questions/1/comments", params: @payload, headers: { "Accept" => "application/json" }
          expect(response).to have_http_status(400)
        end

        it "responds with 400 if nil comment" do
          @payload[:comment][:comment] = nil
          post "/api/v1/questions/1/comments", params: @payload, headers:  { "Accept" => "application/json" }
          expect(response).to have_http_status(400)
        end

        it "responds with 400 if empty author's name" do
          @payload[:comment][:author_name] = ""
          post "/api/v1/questions/1/comments", params: @payload, headers:  { "Accept" => "application/json" }
          expect(response).to have_http_status(400)
        end

        it "responds with 400 if nil author's name" do
          @payload[:comment][:author_name] = nil
          post "/api/v1/questions/1/comments", params: @payload, headers:  { "Accept" => "application/json" }
          expect(response).to have_http_status(400)
        end

        it "strips HTML tags if h4x00rz (remove script balise)" do
          @payload[:comment][:comment] = "<script>alert('coucou')</script>yop"
          post "/api/v1/questions/1/comments", params: @payload, headers:  { "Accept" => "application/json" }
          expect(QuestionComment.first.comment).to eq('yop')
        end
      end

      describe "with valid data" do
        before do
          post "/api/v1/questions/1/comments", params: @payload, headers:  { "Accept" => "application/json" }
        end

        it "responds with 200 code if creation of comment" do
          expect(response).to have_http_status(200)
        end

        it "creates the comment correctly" do
          @question = Question.first
          expect(@question.published_questions.length).to eq(1)
        end
      end
    end

    describe "DELETE #comments" do
      before do
        @comment_to_keep = @question.question_comments.create!(
            :author_name => "James LeSim",
            :comment => "Something really interesting!"
        )
        @comment_to_delete = @question.question_comments.create!(
            :author_name => "John Smith",
            :comment => "Are you sure?"
        )
      end

      describe "with valid data" do
        before do
          delete "/api/v1/questions/1/comments/#{@comment_to_delete.id}", headers: { "Accept" => "application/json" }
        end

        it "responds with 200 code if deletion of comment" do
          expect(response).to have_http_status(204)
        end

        it "deletes the comment correctly" do
          @question.reload
          expect(@question.published_questions.length).to eq(1)
          expect(@question.published_questions.first).to eq(@comment_to_keep)
        end
      end

      describe "with unknown comment" do
        before do
          delete "/api/v1/questions/1/comments/0", headers: { "Accept" => "application/json" }
        end

        it "responds with 404 code if unknown comment" do
          expect(response).to have_http_status(404)
        end

        it "deletes no comment" do
          @question.reload
          expect(@question.published_questions.length).to eq(2)
        end
      end

      describe "with unknown comment for question" do
        before do
          others_question = Question.create!(
              :title => "My other title",
              :answer => "My other answer",
              :user_id => User.first.id
          )
          delete "/api/v1/questions/#{others_question.id}/comments/#{@comment_to_delete.id}", headers: { "Accept" => "application/json" }
        end

        it "responds with 404 code if unknown comment" do
          expect(response).to have_http_status(404)
        end

        it "deletes no comment" do
          @question.reload
          expect(@question.published_questions.length).to eq(2)
        end
      end
    end

  end

end
