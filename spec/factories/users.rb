FactoryBot.define do
  factory :user , aliases: [:followed, :follower] do
    sequence(:name) { |n| "Example User #{n}" }
    sequence(:email) { |n| "example-#{n}@gmail.com" }
    password { "securePassword" }
    password_confirmation { "securePassword" }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin { true }
    end

    trait :invalid do
      name { "" }
      email { "address@invalid" }
      password { "short" }
      password_confirmation { "rack" }
    end

    trait :inactivated do
      activated { false }
      activated_at { nil }
    end

    trait :with_posts do
      after(:create) { |user| create_list(:micropost, 31, user: user) }
    end
  end
end
