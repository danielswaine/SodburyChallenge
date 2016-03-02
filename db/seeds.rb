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

50.times do |num|
  description = Faker::Lorem.sentence
  final_digit = ["0", "5"].sample
  grid_reference_x = Faker::Number.number(3) + final_digit
  grid_reference_y = Faker::Number.number(3) + final_digit
  Checkpoint.create(number: num + 1,
                    grid_reference: grid_reference_x + "-" + grid_reference_y,
                    description: description)
end

p "Seed completed."
p "#{Checkpoint.count} Checkpoints created."
p "#{User.count} Users created."
