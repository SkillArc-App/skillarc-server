FactoryBot.define do
  factory :coaches__seeker_note, class: "Coaches::SeekerNote" do
    association :coach_seeker_context, factory: :coaches__coach_seeker_context

    note { "This is a note" }
    note_id { SecureRandom.uuid }
    note_taken_at { Time.zone.local(2020, 1, 1) }
  end
end
