FactoryGirl.define do
  factory :member do
    sequence(:name) { |n| "Test #{('A'.ord + (n - 1) % 26).chr} Name" }

    association :team
  end
end
