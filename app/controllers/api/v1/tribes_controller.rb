module Api
  module V1
    class TribesController < ApplicationController
      def index
        tribes = Tribe.all.map do |t|
          { type: 'tribe', id: t.id,
            attributes:
            { 'name': t.name,
              'description': t.description,
              'normalized-name': t.normalized_name
            }
          }
        end

        render json: { data: tribes }
      end
    end
  end
end
