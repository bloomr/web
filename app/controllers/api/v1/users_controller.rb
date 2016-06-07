module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        return render json: { error: 'invalid key' }, status: :unauthorized unless params['key'] == ENV['API_KEY']

        permitted = user_params.to_hash
        to_save = permitted.dup
        to_save.delete('keyword_list')

        user = User.new(to_save)
        user.password = Devise.friendly_token.first(8)
        if user.save
          tags = permitted['keyword_list'].split(',').map(&:strip)

          tags.each do |tag|
            capitalized_tag = tag.mb_chars.capitalize.to_s
            keyword = Keyword.find_or_create_by(tag: capitalized_tag)
            KeywordAssociation.find_or_create_by(keyword: keyword, user: user)
          end
          render json: { message: 'creation ok', user_id: user.id }
        else
          render json: { error: 'creation ko', error_description: user.errors.full_messages }, status: :bad_request
        end
      end

      def update
        return render json: { error: 'invalid key' }, status: :unauthorized unless params['key'] == ENV['API_KEY']
        begin
          User.find(params[:id]).update(user_params)
          result = { message: 'update ok', user_id: params[:id] }
          status = :ok
        rescue ActiveRecord::RecordNotUnique => e
          result = {
            error: 'update ko',
            user_id: params[:id],
            error_description: e.message
          }
          status = :bad_request
        end
        render json: result, status: status
      end

      def index
        render json: User.where('published = ?', true),
               only: [:id, :job_title, :first_name]
      end

      def show
        user = User.find(params[:id])

        small_questions_data = user.questions.map { |q| { type: 'question', id: q.id } }
        question_data = user.questions.map do |q|
          { type: 'question', id: q.id,
            attributes:
            { title: q.title, answer: q.answer }
          }
        end

        small_tribes_data = user.tribes.map { |t| { type: 'tribe', id: t.id } }
        tribes_data = user.tribes.map do |t|
          { type: 'tribe', id: t.id,
            attributes:
            { 'name': t.name,
              'description': t.description,
              'normalized-name': t.normalized_name
            }
          }
        end

        small_challenges_data = user.challenges.map { |c| { type: 'challenge', id: c.id } }
        challenges_data = user.challenges.map do |t|
          { type: 'challenge', id: t.id,
            attributes: { 'name': t.name }
          }
        end

        render json:
          { data:
            { type: 'user', id: user.id,
              attributes:
              { 'job-title': user.job_title,
                'first-name': user.first_name,
                'tribes': user.tribes.map { |t| t.name.downcase },
                'stats': {
                  'last-month': user.last_month_view_count,
                  'tribes': user.tribes.reduce(0) { |sum, tribe| sum + tribe.last_month_view_count  },
                  'all': Impression.last_month_count
                }
              },
              relationships:
              {
                questions: {
                  data: small_questions_data
                },
                tribes: {
                  data: small_tribes_data
                },
                challenges: {
                  data: small_challenges_data
                }
              }
            },
            included: question_data + tribes_data + challenges_data
          }
      end

      private

      def user_params
        params.require(:user)
              .permit(:email, :job_title, :first_name, :avatar, :keyword_list,
                      questions_attributes:
                      [:identifier, :title, :answer, :position, :published])
      end
    end
  end
end
