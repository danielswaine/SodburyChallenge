FactoryGirl.define do
  factory :challenge do
    date Faker::Date.between(2.years.ago, 1.year.ago)
    time_allowed 5
    bonus_one ''
    bonus_two ''
    bonus_three ''
    bonus_four ''
    bonus_five ''

    trait(:in_the_future) do
      date Faker::Date.between(1.month.from_now, 1.year.from_now)
    end

    trait(:eight_hour) { time_allowed 8 }
    trait(:published) { published true }

    trait(:with_goals) do
      after :create do |challenge|
        create_list :goal, 10, challenge: challenge
      end
    end

    trait(:with_teams) do
      after :create do |challenge|
        create_list :team, 10, challenge: challenge
      end
    end

    factory :challenge_with_goals_and_teams, traits: [:with_goals, :with_teams]
  end
end
