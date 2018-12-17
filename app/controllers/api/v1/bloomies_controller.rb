module Api
  module V1
    class BloomiesController < ApplicationController
      skip_before_action :verify_authenticity_token
      acts_as_token_authentication_handler_for Bloomy, fallback: :none, only: :show
      before_action :check_bloomy, only: :show

      def show
        bloomy = Bloomy.find(params[:id])
        render json: bloomy, include: %w(programs programs.missions)
      end

      def create
        contract = Contract.find_by(key: params[:key])

        if contract.nil?
          render json: { error: 'Votre entreprise est inconnue. Peut-être y a-t-il une faute dans l\'url ?' }, status: :unauthorized
        else
          bundle = contract.bundles.find_by(name: params[:bundle_name])

          if bundle.nil?
            render json: { error: 'Votre bundle est inconnu. Peut-être y a-t-il une faute dans l\'url ?' }, status: :unauthorized
          else
            bloomy = Bloomy.new(bloomy_parameters.merge(company_name: contract.company_name, coached: true))
            bloomy.programs << bundle.to_program

            if bloomy.save
              render json: {}
            else
              render json: { error: bloomy.errors.full_messages }, status: :unprocessable_entity
            end
          end
        end
      end

      private

      def check_bloomy
        if current_bloomy.nil? || current_bloomy.id != params[:id].to_i
          render json: {}, status: :unauthorized
        end
      end

      def create_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params)
      end

      def bloomy_parameters
        params.permit(:first_name, :name, :email, :password)
      end
    end
  end
end
