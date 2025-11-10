require 'bcrypt'

hashed = BCrypt::Password.create("password")

team = Team.create!(name: "Corporate-1")

user = User.create!(
  name: "Super admin",
  email: "superAdmin@gmail.com",
  password_digest: hashed,
  team: team
)

team.users
user.team

puts "Seeded user: successfully!"
