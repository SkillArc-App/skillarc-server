FactoryBot.define do
  factory :desired_certification do
    id { SecureRandom.uuid }

    master_certification
    job
  end
end
