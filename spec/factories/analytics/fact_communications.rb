FactoryBot.define do
  factory :analytics__fact_communication, class: "Analytics::FactCommunication" do
    dim_person factory: %i[analytics__dim_person]
    dim_user factory: %i[analytics__dim_user]

    kind { Contact::ContactType::PHONE }
    direction { Contact::ContactDirection::RECEIVED }
    occurred_at { Time.zone.local(2022, 4, 17) }
  end
end
