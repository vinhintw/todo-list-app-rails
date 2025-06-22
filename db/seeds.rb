# Clean existing data
puts "Cleaning existing data..."
Tagging.delete_all
Task.delete_all
Tag.delete_all
Session.delete_all
User.delete_all

puts "Creating seed data..."

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
  },
  {
    email_address: "user3@example.com",
    username: "user3",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user4@example.com",
    username: "user4",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user5@example.com",
    username: "user5",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user6@example.com",
    username: "user6",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user7@example.com",
    username: "user7",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user8@example.com",
    username: "user8",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user9@example.com",
    username: "user9",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user10@example.com",
    username: "user10",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user11@example.com",
    username: "user11",
    password: "password123",
    role: :normal
  },
  {
    email_address: "user12@example.com",
    username: "user12",
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

# Create tags
tag_names = [ "work", "personal", "urgent", "meeting", "shopping", "health", "study", "travel" ]

tag_names.each do |tag_name|
  tag = Tag.find_or_create_by!(name: tag_name)
  puts "Created tag: #{tag.name}"
end

# Get all users
all_users = User.all

# Create sample tasks
tasks_data = [
  {
    title: "Complete project proposal",
    content: "Complete project proposal",
    start_time: 1.day.from_now,
    end_time: 3.days.from_now,
    priority: :high,
    status: :pending,
    tag_names: [ "work", "urgent" ]
  },
  {
    title: "Weekly team meeting",
    content: "Weekly team meeting",
    start_time: 2.days.from_now.change(hour: 10),
    end_time: 2.days.from_now.change(hour: 11),
    priority: :medium,
    status: :pending,
    tag_names: [ "work", "meeting" ]
  },
  {
    title: "Grocery shopping",
    content: "Grocery shopping",
    start_time: Time.current,
    end_time: 2.hours.from_now,
    priority: :low,
    status: :in_progress,
    tag_names: [ "personal", "shopping" ]
  },
  {
    title: "Doctor appointment",
    content: "Doctor appointment",
    start_time: 5.days.from_now.change(hour: 14),
    end_time: 5.days.from_now.change(hour: 15),
    priority: :medium,
    status: :pending,
    tag_names: [ "health", "personal" ]
  },
  {
    title: "Study Ruby on Rails",
    content: "Study Ruby on Rails",
    start_time: Time.current,
    end_time: 3.hours.from_now,
    priority: :medium,
    status: :in_progress,
    tag_names: [ "study", "personal" ]
  },
  {
    title: "Plan vacation trip",
    content: "Plan vacation trip",
    start_time: 1.week.from_now,
    end_time: 2.weeks.from_now,
    priority: :low,
    status: :pending,
    tag_names: [ "travel", "personal" ]
  },
  {
    title: "Code review",
    content: "Code review",
    start_time: 1.day.ago,
    end_time: Time.current,
    priority: :high,
    status: :completed,
    tag_names: [ "work" ]
  },
  {
    title: "Update documentation",
    content: "Update documentation",
    start_time: 3.days.ago,
    end_time: 2.days.ago,
    priority: :medium,
    status: :completed,
    tag_names: [ "work" ]
  }
]

# Create tasks for users
tasks_data.each_with_index do |task_data, index|
  user = all_users[index % all_users.count]

  task = Task.create!(
    title: task_data[:title],
    content: task_data[:content],
    start_time: task_data[:start_time],
    end_time: task_data[:end_time],
    priority: task_data[:priority],
    status: task_data[:status],
    user: user
  )

  # Add tags to task
  task_data[:tag_names].each do |tag_name|
    tag = Tag.find_by(name: tag_name)
    if tag
      task.tags << tag unless task.tags.include?(tag)
    end
  end

  puts "Created task: #{task.title} for user #{user.username} with #{task.tags.count} tags"
end

puts "\n=== Seeding completed! ==="
puts "Total users: #{User.count}"
puts "Total tags: #{Tag.count}"
puts "Total tasks: #{Task.count}"
puts "Total taggings: #{Tagging.count}"
