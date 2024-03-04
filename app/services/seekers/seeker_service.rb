module Seekers
  class SeekerService < MessageConsumer
    def handled_messages_sync
      [
        Events::ElevatorPitchCreated::V1
      ].freeze
    end

    def handle_message(message, *_params)
      case message.schema
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
