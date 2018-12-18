FactoryBot.define do
  factory :bundle do
    sequence(:name) { |n| "name_#{n}" }
  end

  trait :with_program_template do
      after(:create) do |bundle, _evaluator|
        bundle.program_templates << create(:program_template)
      end
  end
end
