FactoryBot.define do
  factory :employer do
    id { SecureRandom.uuid }
    name { "Acme Inc." }
    bio { "We are a company." }
  end
end
