FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }

    planned_start_time do
      format('%<hour>d:%<minute>02d', hour: rand(17..23), minute: 5 * rand(12))
    end

    # FIXME: cannot create/build team on its own without this line. Currently,
    # a challenge must be created using the with_teams trait.
    challenge_id 1

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
