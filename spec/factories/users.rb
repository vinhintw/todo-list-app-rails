FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 5..15) }
    email_address { Faker::Internet.email }
    password { "password123" }
    role { :normal }

    trait :admin do
      role { :admin }
    end
  end
end
