FactoryGirl.define do
  factory :program do
    sequence(:name) { |n| "program#{n}" }
  end
end
