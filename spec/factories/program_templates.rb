FactoryBot.define do
  factory :program_template do
    sequence(:name) { |n| "program_template_name_#{n}" }
    discourse { false }
    intercom { false }
  end
end
