FactoryBot.define do
  factory :recruiter do
    id { SecureRandom.uuid }

    user
    employer
  end
end
