FactoryBot.define do
  factory :coaches__coach, class: "Coaches::Coach" do
    user_id { SecureRandom.uuid }
    email { Faker::Internet.email }
  end
end
