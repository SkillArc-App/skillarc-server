FactoryBot.define do
  factory :infrastructure__task, class: "Infrastructure::Task" do
    id { SecureRandom.uuid }
    execute_at { Time.zone.local(2020, 1, 1) }
    state { Infrastructure::TaskStates::ENQUEUED }
    command do
      build(
        :message,
        schema: Commands::AssignCoach::V1,
        aggregate_id: SecureRandom.uuid,
        data: {
          coach_email: "coach@skillarc.com"
        }
      )
    end
  end
end
