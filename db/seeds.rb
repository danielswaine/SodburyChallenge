Challenge.destroy_all
Checkpoint.destroy_all
User.destroy_all
Goal.destroy_all
Member.destroy_all
Message.destroy_all
Team.destroy_all

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

Challenge.all.each do |ch|
  15.times do
    Goal.create(challenge_id: ch.id,
                checkpoint_id: (1..50).to_a.sample,
                points_value: rand(50),
                compulsory: false,
                start_point: false)
  end
end

p "#{Goal.count} Goals created."

Challenge.all.each_with_index do |ch, idx|

  challenge = ch.date
  day = challenge.day.to_i
  month = challenge.month.to_i
  year = challenge.year.to_i

  20.times do |num|
    Team.create(challenge_id: ch.id,
                group: [:scouts, :explorers, :non_competitive, :network, :leaders].sample,
                name: "Team #{num + 1}",
                planned_start_time: "%d:%02d" % [rand(17..23), 5 * rand(12)])

    5.times do
      Message.create(
        team_number: num + 1,
        date: Date.new(year, month, day),
        time: "%d:%02d" % [rand(17..23), 5 * rand(12)],
        latitude: rand(51.537422..51.641655).round(5).to_s,
        longitude: rand(-2.516653..-2.34929).round(5).to_s,
        speed: rand(10),
        battery: rand(100),
        signal_strength: rand(100),
        mobile_number: "+447123456789"
      )
    end
  end
end

p "#{Team.count} Teams created."
p "#{Message.count} Messages created"

25.times do |num|
  5.times do
    Member.create(name: Faker::Name.name,
                  team_id: num + 1)
  end
end

p "#{Member.count} Members created."
