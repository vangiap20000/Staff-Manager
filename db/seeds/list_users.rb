require 'faker'

team = Team.find_or_create_by!(name: "Corporate-1")

50.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email, 
    password: "password",
    team: team,
    role: Rails.configuration.const['role'][:member]
  )

  team.users
  user.team
end

puts "Seeded 50 fake users successfully!"
