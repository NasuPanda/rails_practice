FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "example@email.com" }
    password { "securePassword" }
    password_confirmation { "securePassword" }
    admin { true }
  end

  factory :other_user ,class: User do
    name { "Another User" }
    email { "another@gmail.com" }
    password { "securePassword" }
    password_confirmation { "securePassword" }
  end

  factory :invalid_user, class: User do
    name { "" }
    email { "address@invalid" }
    password { "short" }
    password_confirmtaion { "rack" }
  end

  factory :many_users, class: User do
    sequence(:name) { |n| "Example User #{n}" }
    sequence(:email) { |n| "example-#{n}@gmail.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end

end
