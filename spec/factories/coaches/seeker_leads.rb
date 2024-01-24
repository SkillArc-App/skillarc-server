FactoryBot.define do
  factory :coaches__seeker_lead, class: "Coaches::SeekerLead" do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { nil }
    phone_number { Faker::PhoneNumber.phone_number }
    status { Coaches::SeekerLead::StatusTypes::NEW }
    lead_captured_at { Time.zone.local(2021, 2, 2) }
    lead_captured_by { Faker::Internet.email }
  end
end
