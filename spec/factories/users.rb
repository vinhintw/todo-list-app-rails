FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..15) }
    email_address { Faker::Internet.email }
    password { "password123" }
    role { Role.find_or_create_by(name: "user") }

    trait :admin do
      role { Role.find_or_create_by(name: "admin") }
    end
  end

  factory :role, aliases: [ :user_role ] do
    name { "user" }
  end

  factory :admin_role, class: Role do
    name { "admin" }
  end
end
