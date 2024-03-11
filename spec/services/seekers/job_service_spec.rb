require 'rails_helper'

RSpec.describe Seekers::JobService do
  describe "#add_elevator_pitch" do
    subject { described_class.new(job:, seeker:).add_elevator_pitch(elevator_pitch) }

    include_context "event emitter"

    let(:job) { create(:job) }
    let(:seeker) { create(:seeker) }
    let!(:applicant) { create(:applicant, job:, seeker:) }

    let(:elevator_pitch) { "New Elevator Pitch" }

    it "publishes an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::ElevatorPitchCreated::V1,
        seeker_id: seeker.id,
        data: Events::ElevatorPitchCreated::Data::V1.new(
          job_id: job.id,
          pitch: elevator_pitch
        )
      )

      subject
    end
  end
end
