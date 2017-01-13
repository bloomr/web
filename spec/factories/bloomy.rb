FactoryGirl.define do
  factory :bloomy do
    first_name 'bloomy'
    sequence(:email) { |n| "bloomy#{n}@b.com" }
    age 21
    password 'bloomy12'
  end
end
