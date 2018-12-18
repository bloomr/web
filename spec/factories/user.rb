FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name 'John'
    job_title 'Developer'
    password 'abcdfedv'

    factory :user_published_with_questions do
      transient do
        questions_count 2
        question_love_job true
      end

      after(:create) do |user, evaluator|

        nb_questions_to_add = evaluator.question_love_job ? evaluator.questions_count - 1 : evaluator.questions_count
        create_list(:question, nb_questions_to_add, user: user)

        if evaluator.question_love_job
           user.questions << create(:question, identifier: 'love_job')
           user.published = true
           user.save!
        end

      end
    end
  end
end
