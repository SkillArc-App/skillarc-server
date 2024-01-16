FactoryBot.define do
  factory :read_receipt do
    read_at { Time.zone.now }
  end
end
