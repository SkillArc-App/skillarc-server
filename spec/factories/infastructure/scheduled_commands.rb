FactoryBot.define do
  factory :infastructure__scheduled_command, class: "Infastructure::ScheduledCommand" do
    execute_at { Time.zone.local(2020, 1, 1) }
    state { Infastructure::ScheduledCommand::State::ENQUEUED }
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
