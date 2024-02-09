FactoryBot.define do
  factory :seeker_invite do
    id { SecureRandom.uuid }

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    training_provider
    program
  end
end
