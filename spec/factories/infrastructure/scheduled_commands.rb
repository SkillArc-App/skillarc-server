FactoryBot.define do
  factory :infrastructure__scheduled_command, class: "Infrastructure::ScheduledCommand" do
    execute_at { Time.zone.local(2020, 1, 1) }
    state { Infrastructure::ScheduledCommand::State::ENQUEUED }
    task_id { SecureRandom.uuid }
    message do
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
