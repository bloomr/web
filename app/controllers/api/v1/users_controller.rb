module Api
  module V1

    class UsersController < ApplicationController

      skip_before_action :verify_authenticity_token, only: [:create, :update]

      def create
        return render json: {error:"invalid key"}, status: :unauthorized unless params["key"] == ENV["API_KEY"]

        @user = User.new(user_params)
        @user.password = Devise.friendly_token.first(8)
        if @user.save
          tags = user_params["keyword_list"].split(",").map{|t| t.strip}

          tags.each do |tag|
            capitalized_tag = tag.mb_chars.capitalize.to_s
            keyword = Keyword.find_or_create_by(:tag => capitalized_tag)
            KeywordAssociation.find_or_create_by(:keyword => keyword, :user => @user)
          end
          render json: {message: 'creation ok', user_id: @user.id}
        else
          render json: {error: "creation ko", error_description: @user.errors.full_messages}, status: :bad_request
        end
      end

      def update
        return render json: {error:"invalid key"}, status: :unauthorized unless params["key"] == ENV["API_KEY"]
        begin
          User.find(params[:id]).update(user_params)
          result = {message: 'update ok', user_id: params[:id]}
          status = :ok
        rescue ActiveRecord::RecordNotUnique => e
          result = {error: 'update ko', user_id: params[:id], error_description: e.message}
          status = :bad_request
        end
        render json: result, status: status
      end

      def index
        render json: User.where("published = ?", true), :only => [:id, :job_title, :first_name]
      end

      private
      def user_params
        params.require(:user).permit(:email, :job_title, :first_name, :avatar, :keyword_list, questions_attributes: [:identifier, :title, :answer, :position, :published])
      end

    end

  end
end


