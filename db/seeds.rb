User.create!(name:  "Test User",
             email: "test@test.com",
             password:              "testingtesting123",
             password_confirmation: "testingtesting123",
             admin: false)

User.create!(name:  "Admin User",
             email: "admin@admin.com",
             password:              "adminadmin123",
             password_confirmation: "adminadmin123",
             admin: true)

50.times do |num|
  Checkpoint.create!(number: num + 1,
                     grid_reference: "2345-7890",
                     description: "Example checkpoint number #{num + 1}")
end
