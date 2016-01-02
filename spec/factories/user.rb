FactoryGirl.define do
  factory :user do
    email 'yopyop@yop.com'
    first_name 'John'
    job_title 'Developer'
    password 'abcdfedv'
    published true

    factory :user_with_questions do
      transient do
        questions_count 2
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user: user)
      end
    end
  end
end
