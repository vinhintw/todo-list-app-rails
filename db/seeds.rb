# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default admin user
admin_user = User.find_or_create_by!(username: "admin") do |user|
  user.email_address = "admin@example.com"
  user.password = "admin123"
  user.password_confirmation = "admin123"
  user.role = :admin
end

puts "Admin user created: #{admin_user.username} (#{admin_user.email_address})"

# Create default normal user
normal_user = User.find_or_create_by!(username: "user") do |user|
  user.email_address = "user@example.com"
  user.password = "user123"
  user.password_confirmation = "user123"
  user.role = :normal
end

puts "Normal user created: #{normal_user.username} (#{normal_user.email_address})"
