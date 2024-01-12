FactoryBot.define do
  factory :seeker_note do
    coach_seeker_context

    note { "This is a note" }
    note_id { SecureRandom.uuid }
    note_taken_at { Time.new(2020, 1, 1) }
  end
end
