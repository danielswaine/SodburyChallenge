FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Test #{('A'.ord + (n - 1) % 26).chr} User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:password) { |n| "test password #{n}" }

    password_confirmation { password }

    trait(:admin) { admin true }
  end
end
