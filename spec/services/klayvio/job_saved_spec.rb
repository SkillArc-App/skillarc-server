require 'rails_helper'

RSpec.describe Klayvio::JobSaved do
  describe "#call" do
    subject { described_class.new.call(message:) }

    let(:message) do
      build(
        :message,
        :job_saved,
        aggregate_id: user.id,
        data: Events::Common::UntypedHashWrapper.new(
          job_id: "A",
          employment_title: "Welder",
          employer_name: "Acme Inc."
        )
      )
    end

    let(:user) { create(:user) }

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:job_saved).with(
        email: user.email,
        event_id: message.id,
        event_properties: {
          job_id: "A",
          employment_title: "Welder",
          employer_name: "Acme Inc."
        },
        occurred_at: message.occurred_at
      )

      subject
    end
  end
end
