include ActionView::Helpers::SanitizeHelper

module Api
  module V1

    class CommentsController < ApplicationController

      before_filter :load_question

      def index
        render json: @question.published_questions
      end

      def create
        @comment = @question.question_comments.new(comment_params)
        if @comment.save
          notify_slack @comment
          render json: { message: "creation ok", comment_id: @comment.id }
        else
          render json: { error: "creation ko", error_description: @comment.errors.full_messages }, status: :bad_request
        end
      end

      def destroy
        if comment = QuestionComment.where(id: params[:id], question_id: params[:question_id]).first
          comment.update(published: false)
          head :no_content
        else
          head :not_found
        end
      end

      private
      def load_question
        @question = Question.find(params[:question_id])
      end

      def comment_params
        comment_raw_params = params.require(:comment).permit(:author_avatar_url, :author_name, :comment, :question_id)
        comment_raw_params.reduce({}) { |hash, (k, v)| hash.merge(k => strip_tags(v)) }
      end

      def notify_slack comment
        uri = ENV['SLACK_COMMENTS_WEBHOOK']
        if uri
          message = "Nouveau commentaire '" + comment.comment + "' sur le portrait " + portrait_url(@question.user.id)
          RestClient.post uri, { 'text' => message }.to_json, :content_type => :json
        end
      end
    end

  end
end
