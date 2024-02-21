module Seekers
  class JobService
    def initialize(job:, seeker:)
      @job = job
      @seeker = seeker
    end

    def add_elevator_pitch(elevator_pitch)
      EventService.create!(
        event_schema: Events::ElevatorPitchCreated::V1,
        aggregate_id: seeker.id,
        data: Events::ElevatorPitchCreated::Data::V1.new(
          job_id: job.id,
          pitch: elevator_pitch
        )
      )
    end

    private

    attr_reader :job, :seeker
  end
end
