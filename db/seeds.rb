# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a confirmed test user
puts "Creating seed user..."

user = User.find_or_initialize_by(email: "test@example.com")
user.assign_attributes(
  name: "Test User",
  mobile_no: "1234567890",
  password: "password123",
  password_confirmation: "password123",
  confirmed_at: Time.current
)

if user.save
  puts "Seed user created successfully!"
  puts "Email: test@example.com"
  puts "Password: password123"
else
  puts "Failed to create seed user: #{user.errors.full_messages.join(', ')}"
end