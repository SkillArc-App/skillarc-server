FactoryBot.define do
  factory :training_provider_invite do
    id { SecureRandom.uuid }
    training_provider

    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role_description { Faker::Lorem.paragraph }
  end
end
