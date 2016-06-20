module Api
  module V1
    class UserResource < JSONAPI::Resource
      before_update :authorize_update

      attributes :job_title, :first_name, :stats, :avatar_url

      relationship :tribes, to: :many
      relationship :questions, to: :many, relation_name: :interview_questions
      relationship :books, to: :many
      relationship :challenges, to: :many

      def stats
        {
          'last-month': @model.last_month_view_count,
          'tribes': tribe_stat,
          'all': Impression.last_month_count
        }
      end

      def avatar_url
        @model.avatar.url('thumb')
      end

      private

      def authorize_update
        if context[:user].nil? || @model.id != context[:user].id
          fail Exceptions::NotAuthorizedError
        end
      end

      def tribe_stat
        @model.tribes.reduce(0) do |sum, tribe|
          sum + tribe.last_month_view_count
        end
      end
    end
  end
end
