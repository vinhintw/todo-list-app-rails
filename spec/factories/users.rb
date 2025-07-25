FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..15) }
    email_address { Faker::Internet.email }
    password { "password123" }
    role { Role.find_or_create_by(name: Role::USER) }

    trait :admin do
      role { Role.find_or_create_by(name: Role::ADMIN) }
    end

    trait :normal do
      role { Role.find_or_create_by(name: Role::USER) }
    end
  end

  factory :role, aliases: [ :user_role ] do
    name { Role::USER }
  end

  factory :admin_role, class: Role do
    name { Role::ADMIN }
  end
end
