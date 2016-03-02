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
