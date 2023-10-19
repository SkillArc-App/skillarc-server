FactoryBot.define do
  factory :profile do
    id { SecureRandom.uuid }
    user
  end
end
