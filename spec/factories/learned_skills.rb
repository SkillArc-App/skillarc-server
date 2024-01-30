FactoryBot.define do
  factory :learned_skill do
    id { SecureRandom.uuid }

    master_skill
    job
  end
end
