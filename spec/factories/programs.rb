FactoryBot.define do
  factory :program do
    id { SecureRandom.uuid }

    name { "Welding" }
    description { "Learn to weld" }
  end
end
