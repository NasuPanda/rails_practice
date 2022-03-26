FactoryBot.define do
  factory :micropost do
    content { "Test post" }
    association :user

    trait :most_recent do
      created_at { Time.zone.now }
    end

    trait :some_time_ago do
      created_at { 30.minutes.ago }
    end

    trait :yesterday do
      created_at { 1.day.ago }
    end

    trait :last_week do
      created_at { 1.week.ago }
    end

  end
end

def posts_different_posting_time
  FactoryBot.create(:micropost, :some_time_ago)
  FactoryBot.create(:micropost, :yesterday)
  FactoryBot.create(:micropost, :last_week)
end
