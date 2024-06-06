FactoryBot.define do
  factory :coaches__person_note, class: "Coaches::PersonNote" do
    association :person_context, factory: :coaches__person_context

    note { "This is a note" }
    note_taken_at { Time.zone.local(2020, 1, 1) }
    note_taken_by { "coach@blocktrainapp.com" }
  end
end
