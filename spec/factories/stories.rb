FactoryBot.define do
  factory :story do
    id { SecureRandom.uuid }

    prompt { "This is a prompt" }
    response { "This is a response" }
  end
end
