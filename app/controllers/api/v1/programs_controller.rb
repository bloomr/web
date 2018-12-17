module Api
  module V1
    class ProgramsController < ApplicationController
      skip_before_action :verify_authenticity_token
      acts_as_token_authentication_handler_for Bloomy, fallback: :none
      before_action :check_bloomy

      def show
        program = Program.find(params[:id])
        render json: program, include: %w(missions)
      end

      def update
        h = create_params
        program = Program.update(h[:id], h)
        render json: program
      end

      private

      def check_bloomy
        if current_bloomy.nil? || !current_bloomy.programs.pluck(:id).include?(params[:id].to_i)
          render json: {}, status: :unauthorized
        end
      end

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end
    end
  end
end
