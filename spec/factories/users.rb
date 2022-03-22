FactoryBot.define do
  factory :user do
    name { "Example User" }
    email { "example@email.com" }
    password { "securePassword" }
    password_confirmation { "securePassword" }
  end

  factory :invalid_user, class: User do
    name { "" }
    email { "address@invalid" }
    password { "short" }
    password_confirmtaion { "rack" }
  end
end
