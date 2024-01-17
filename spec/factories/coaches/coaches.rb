FactoryBot.define do
  factory :coaches__coach, class: "Coaches::Coach" do
    coach_id { SecureRandom.uuid }
    user_id { SecureRandom.uuid }
    email { Faker::Internet.email }
  end
end
