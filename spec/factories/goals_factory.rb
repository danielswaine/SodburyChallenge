FactoryGirl.define do
  factory :goal do
    sequence(:points_value) { |n| n * 10 }

    trait(:compulsory) { compulsory true }
    trait(:start_point) { start_point true }

    challenge
    checkpoint
  end
end
