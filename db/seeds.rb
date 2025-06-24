# Create admin user
admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.username = "admin"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :admin
end

puts "Created admin user: #{admin.username} (#{admin.email_address})"

# Create normal users
users_data = [
  {
    email_address: "user1@example.com",
    username: "user1",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user2@example.com",
    username: "user2",
    password: "password123",
    role: :normal
  }
]

users_data.each do |user_attrs|
  user = User.find_or_create_by!(email_address: user_attrs[:email_address]) do |u|
    u.username = user_attrs[:username]
    u.password = user_attrs[:password]
    u.password_confirmation = user_attrs[:password]
    u.role = user_attrs[:role]
  end

  puts "Created user: #{user.username} (#{user.email_address}) - Role: #{user.role}"
end

puts "Seeding completed! Total users: #{User.count}"
