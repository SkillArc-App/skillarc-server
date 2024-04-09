require 'rails_helper'

RSpec.describe Seekers::ApplicantService do
  describe "#apply" do
    subject { described_class.new(seeker).apply(job) }

    include_context "event emitter", false

    let(:seeker) { create(:seeker, user:) }
    let(:user) do
      create(
        :user,
        first_name: "Katina",
        last_name: "Hall",
        email: "katina.hall@skillarc.com",
        phone_number: "123-456-7890"
      )
    end
    let(:job) { create(:job, employer:, employment_title: "Welder") }
    let(:employer) do
      create(
        :employer,
        name: "Skillarc"
      )
    end

    it "publishes an event" do
      expect_any_instance_of(MessageService)
        .to receive(:create!)
        .with(
          seeker_id: seeker.id,
          schema: Events::SeekerApplied::V1,
          data: Events::SeekerApplied::Data::V1.new(
            seeker_first_name: "Katina",
            seeker_last_name: "Hall",
            seeker_email: "katina.hall@skillarc.com",
            seeker_phone_number: "123-456-7890",
            seeker_id: seeker.id,
            job_id: job.id,
            employer_name: "Skillarc",
            employment_title: "Welder"
          ),
          metadata: Messages::Nothing,
          version: 1
        ).and_call_original

      subject
    end
  end
end
