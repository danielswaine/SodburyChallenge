FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }

    planned_start_time '18:00'

    association :challenge

    sequence(:group) { |n| n % 7 }

    trait(:disqualified) { disqualified true }
    trait(:dropped_out) { dropped_out true }
    trait(:forgot_to_phone_in) { forgot_to_phone_in true }

    trait(:with_members) do
      after :create do |team|
        create_list :member, 5, team: team
      end
    end
  end
end
