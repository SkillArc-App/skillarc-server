FactoryBot.define do
  factory :job_attribute do
    attribute_id { SecureRandom.uuid }
    attribute_value_ids { [SecureRandom.uuid] }
    job
  end
end
