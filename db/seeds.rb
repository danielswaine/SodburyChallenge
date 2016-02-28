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
  Checkpoint.create(number: num + 1,
                    grid_reference: "2839-1028",
                    description: description
                    )
end
