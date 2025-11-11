require 'bcrypt'

hashed = BCrypt::Password.create("password")

team = Team.find_or_create_by!(name: "Corporate-1")

CONST = Rails.configuration.const
role = CONST['role']

role.each do |key, value|
  user = User.create!(
    name: key.capitalize,
    email: "#{key}@gmail.com",
    password_digest: hashed,
    team: team,
    role: value
  )
  
  team.users
  user.team
end

puts "Seeded user: successfully!"
