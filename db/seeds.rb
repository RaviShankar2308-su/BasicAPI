# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Creating User'
user1 = User.create(email: 'user1@example.com', password: '12345678')
user2 = User.create(email: 'user2@example.com', password: '12345678', role: 'admin')
puts 'User created successfully'
puts "User email id: #{user1.email} and password: #{user1.password}"
puts "Admin email id: #{user2.email} and password: #{user2.password}"

puts 'Creating Company'
user = User.first
company1 = Company.create(name: 'Test', location: 'India', user_id: user.id)
company2 = Company.create(name: 'Test2', location: 'India', user_id: user.id)
puts "Company #{company1.name} and #{company2.name} created successfully"