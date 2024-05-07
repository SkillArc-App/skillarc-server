FactoryBot.define do
  factory :user_role do
    association :user
    association :role

    id { SecureRandom.uuid }
  end
end
