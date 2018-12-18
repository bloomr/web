FactoryBot.define do
  factory :bloomy do
    first_name 'bloomy'
    name 'Dumont'
    sequence(:email) { |n| "bloomy#{n}@b.com" }
    age 21
    password 'bloomy12'
  end
end
