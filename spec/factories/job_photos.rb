FactoryBot.define do
  factory :job_photo do
    id { SecureRandom.uuid }

    photo_url { "https://www.example.com" }
  end
end
