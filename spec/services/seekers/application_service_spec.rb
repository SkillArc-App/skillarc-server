require 'rails_helper'

RSpec.describe Seekers::ApplicationService do
  describe ".apply" do
    subject { described_class.apply(job:, seeker:, message_service:) }

    let(:message_service) { MessageService.new }
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
      expect(message_service)
        .to receive(:create!)
        .with(
          seeker_id: seeker.id,
          schema: Events::SeekerApplied::V2,
          data: {
            application_id: be_a(String),
            seeker_first_name: "Katina",
            seeker_last_name: "Hall",
            seeker_email: "katina.hall@skillarc.com",
            seeker_phone_number: "123-456-7890",
            user_id: seeker.user.id,
            job_id: job.id,
            employer_name: "Skillarc",
            employment_title: "Welder"
          }
        ).and_call_original

      subject
    end
  end
end
