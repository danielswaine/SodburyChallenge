FactoryGirl.define do
  factory :checkpoint do
    sequence(:number) { |n| n }
    sequence(:grid_reference) do
      format(
        '%<easting>04d-%<northing>04d',
        easting: (5 * rand(2000)),
        northing: (5 * rand(2000))
      )
    end
    sequence(:description) { Faker::Lorem.sentence }
  end
end
