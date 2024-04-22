require 'rails_helper'

RSpec.describe Klayvio::ApplicationStatusUpdated do
  describe "#call" do
    let(:message) do
      build(
        :message,
        schema: Events::ApplicantStatusUpdated::V6,
        aggregate_id: SecureRandom.uuid,
        data: {
          applicant_first_name: "John",
          applicant_last_name: "Chabot",
          applicant_email: "john@skillar.com",
          seeker_id: SecureRandom.uuid,
          user_id: SecureRandom.uuid,
          job_id: SecureRandom.uuid,
          employer_name: "A employer",
          employment_title: "A title",
          status: "new"
        },
        metadata: {}
      )
    end

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::FakeGateway).to receive(:application_status_updated).with(
        application_id: message.aggregate.id,
        email: message.data.applicant_email,
        employment_title: message.data.employment_title,
        employer_name: message.data.employer_name,
        event_id: message.id,
        occurred_at: message.occurred_at,
        status: "new"
      )

      subject.call(message:)
    end
  end
end
