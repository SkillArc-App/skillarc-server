FactoryBot.define do
  factory :role do
    id { SecureRandom.uuid }
    name { "A role" }
  end
end
