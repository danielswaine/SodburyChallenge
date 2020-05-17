FactoryGirl.define do
  factory :member do
    sequence(:name) { |n| "Test #{('A'.ord + (n - 1) % 26).chr} Name" }

    # FIXME: cannot create/build member on its own without this line. Currently,
    # a team must be created using the with_members trait.
    team_id 1
  end
end
