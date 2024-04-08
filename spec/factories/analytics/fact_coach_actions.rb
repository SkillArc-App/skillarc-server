FactoryBot.define do
  factory :analytics__fact_coach_action, class: "Analytics::FactCoachAction" do
    association :dim_person_executor, factory: :analytics__dim_person
    association :dim_person_target, factory: :analytics__dim_person

    action { Analytics::FactCoachAction::Actions::NOTE_ADDED }
    action_taken_at { Time.zone.local(2023, 11, 5) }
  end
end
