FactoryGirl.define do
  factory :goal do
    points_value 10

    trait(:compulsory) { compulsory true }
    trait(:start_point) { start_point true }

    association :challenge
    association :checkpoint
  end
end
