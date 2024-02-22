module Seekers
  class SeekerService < EventConsumer
    def handled_events_sync
      [
        Events::ElevatorPitchCreated::V1
      ].freeze
    end

    def handle_event(message, *_params)
      case message.event_schema
      when Events::ElevatorPitchCreated::V1
        handle_elevator_pitch_created(message)
      end
    end

    def reset_for_replay
      # We can't fill this in yet since seekers aren't fully event sourced
    end

    private

    def handle_elevator_pitch_created(message)
      applicant = Applicant.find_by!(
        job: message.data.job_id,
        seeker_id: message.aggregate_id
      )

      applicant.update!(
        elevator_pitch: message.data.pitch
      )
    end
  end
end
