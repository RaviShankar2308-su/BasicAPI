FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    location { Faker::Address.city }
    association :user, factory: :user
  end
end
