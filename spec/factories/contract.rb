FactoryBot.define do
  factory :contract do
    sequence(:company_name) { |n| "company_#{n}" }
    sequence(:key) { |n| "key_#{n}" }
  end
end
