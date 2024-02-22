require 'rails_helper'

RSpec.describe Seekers::SeekerService do
  let(:elevator_pitch_created) do
    build(
      :events__message,
      :elevator_pitch_created,
      aggregate_id: seeker.id,
      data: Events::ElevatorPitchCreated::Data::V1.new(
        job_id:,
        pitch: "pitch"
      )
    )
  end
  let(:job) { create(:job) }
  let(:job_id) { job.id }
  let(:seeker) { create(:seeker) }
  let!(:applicant) { create(:applicant, seeker:, job:) }

  it_behaves_like "an event consumer"

  describe "elevator pitch added" do
    before do
      described_class.handle_event(elevator_pitch_created)
    end

    it "updates the seeker's elevator pitch" do
      expect(applicant.reload.elevator_pitch).to eq("pitch")
    end
  end
end
