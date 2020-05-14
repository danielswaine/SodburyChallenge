FactoryGirl.define do
  factory :checkpoint do
    sequence(:number) { |n| n }
    sequence(:grid_reference) { "%04d-%04d" % [(5 * rand(2000)), (5 * rand(2000))] }
    sequence(:description) { Faker::Lorem.sentence }
  end
end
