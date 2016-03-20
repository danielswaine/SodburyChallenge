User.create(name:  "Test User",
            email: "test@test.com",
            password:              "testingtesting123",
            password_confirmation: "testingtesting123",
            admin: false)

User.create(name:  "Admin User",
            email: "admin@admin.com",
            password:              "adminadmin123",
            password_confirmation: "adminadmin123",
            admin: true)

p "#{User.count} Users created."

50.times do |num|
  description = Faker::Lorem.sentence
  Checkpoint.create(number: num + 1,
                    grid_reference: "%04d-%04d" % [(5 * rand(2000)), (5 * rand(2000))],
                    description: description)
end

p "#{Checkpoint.count} Checkpoints created."

2.times do
  date = Faker::Date.forward
  Challenge.create(date: date,
                   time_allowed: [5, 8].sample)
end

p "#{Challenge.count} Challenges created."

15.times do |num|
  Team.create(challenge_id: [1, 2].sample,
              group: [:scouts, :explorers, :non_competitive].sample,
              name: "Team #{num + 1}",
              planned_start_time: "%d:%02d" % [rand(13..23), rand(0..59)])
end

p "#{Team.count} Teams created."

15.times do |num|
  5.times do
    Member.create(name: Faker::Name.name,
                  team_id: num + 1)
  end
end

p "#{Member.count} Members created."
