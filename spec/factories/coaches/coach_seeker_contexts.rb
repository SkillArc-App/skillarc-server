FactoryBot.define do
  factory :coaches__coach_seeker_context, class: "Coaches::CoachSeekerContext" do
    user_id { SecureRandom.uuid }
    seeker_id { SecureRandom.uuid }
    kind { Coaches::CoachSeekerContext::Kind::SEEKER }
    assigned_coach { SecureRandom.uuid }
    certified_by { "jim@cool.com" }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
