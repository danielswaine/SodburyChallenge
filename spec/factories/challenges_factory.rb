FactoryGirl.define do
  factory :challenge do
    date Faker::Date.between(2.years.ago, 1.year.ago)
    time_allowed 5

    trait(:in_the_future) do
      date Faker::Date.between(1.month.from_now, 1.year.from_now)
    end

    trait(:eight_hour) { time_allowed 8 }
    trait(:published) { published true }

    trait(:with_goals) do
      after :create do |challenge|
        create :goal, :compulsory, points_value: 50, challenge: challenge
        create_list :goal, 5, challenge: challenge
      end
    end

    trait(:with_team) do
      after :create do |challenge|
        create :team, challenge: challenge
      end
    end

    factory :challenge_with_goals_and_team, traits: [:with_goals, :with_team]
  end
end
