FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    content { Faker::Lorem.paragraph(sentence_count: 3) }
    start_time { 1.hour.from_now }
    end_time { 3.hours.from_now }
    priority { :medium }
    status { :pending }
    association :user

    trait :high_priority do
      priority { :high }
    end

    trait :urgent do
      priority { :urgent }
    end

    trait :completed do
      status { :completed }
    end

    trait :in_progress do
      status { :in_progress }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :no_time do
      start_time { nil }
      end_time { nil }
    end

    trait :invalid_time do
      start_time { 1.hour.from_now }
      end_time { 30.minutes.from_now }
    end
  end
end
