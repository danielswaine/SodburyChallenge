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

4.times do
  date = Faker::Date.between(2.years.ago, 1.year.from_now)
  Challenge.create(date: date, time_allowed: 5)
  Challenge.create(date: date, time_allowed: 8)
end

p "#{Challenge.count} Challenges created."

4.times do |num|
  15.times do
    Goal.create(challenge_id: num + 1,
                checkpoint_id: (1..50).to_a.sample,
                points_value: rand(50),
                compulsory: false,
                start_point: false)
  end
end

p "#{Goal.count} Goals created."

Challenge.count.times do |ch|
  20.times do |num|
    Team.create(challenge_id: ch + 1,
                group: [:scouts, :explorers, :non_competitive, :network, :leaders].sample,
                name: "Team #{num + 1}",
                planned_start_time: "%d:%02d" % [rand(17..23), 5 * rand(12)])
  end
end
p "#{Team.count} Teams created."

25.times do |num|
  5.times do
    Member.create(name: Faker::Name.name,
                  team_id: num + 1)
  end
end

p "#{Member.count} Members created."
