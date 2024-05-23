module Seekers
  class SeekerService < MessageConsumer
    def reset_for_replay
      # We can't fill this in yet since seekers aren't fully event sourced
    end

    on_message Events::ElevatorPitchCreated::V1, :sync do |message|
      applicant = Applicant.find_by!(
        job_id: message.data.job_id,
        seeker_id: message.aggregate_id
      )

      applicant.update!(
        elevator_pitch: message.data.pitch
      )
    end
  end
end
