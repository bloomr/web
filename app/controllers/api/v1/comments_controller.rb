module Api
  module V1

    class CommentsController < ApplicationController

      before_filter :load_question

      def index
        @comments = @question.question_comments
        render json: @comments
      end

      def create
        @comment = @question.question_comments.new(comment_params)
        if @comment.save
          render json: { message: "creation ok", comment_id: @comment.id }
        else
          render json: { error: "creation ko", error_description: @comment.errors.full_messages }, status: :bad_request
        end
      end

      private
      def load_question
        @question = Question.find(params[:question_id])
      end

      def comment_params
        params.require(:comment).permit(:author_avatar_url, :author_name, :comment, :question_id);
      end
    end

  end
end
