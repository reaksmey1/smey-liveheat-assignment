# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Create students
students = []
10.times do
  students << Student.create(name: Faker::Name.name)
end

# Create a race with at least 2 students assigned to it
race = Race.create(name: 'Sprint Race', number_of_lanes: 5)

# Assign students to lanes (without repeating a student in the same race)
students[0..4].each_with_index do |student, index|
  Lane.create(race: race, student: student, lane_number: index + 1)
end

puts "Created a race with #{race.number_of_lanes} lanes and students assigned!"