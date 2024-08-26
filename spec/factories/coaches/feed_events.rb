FactoryBot.define do
  factory :coaches__feed_event, class: "Coaches::FeedEvent" do
    person_id { SecureRandom.uuid }
    person_email { Faker::Internet.email }
    person_phone { Faker::PhoneNumber.phone_number }
    occurred_at { Time.current }
  end
end
