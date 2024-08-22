FactoryBot.define do
  factory :coaches__contacts, class: "Coaches::Contact" do
    person_context factory: %i[coaches__person_context]

    note { "This is a note" }
    contacted_at { Time.zone.local(2021, 1, 1) }
    contact_type { Contact::ContactType::SMS }
    contact_direction { Contact::ContactDirection::SENT }
  end
end
