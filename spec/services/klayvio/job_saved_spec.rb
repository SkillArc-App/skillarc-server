require 'rails_helper'

RSpec.describe Klayvio::JobSaved do
  describe "#call" do
    subject { described_class.new.call(event: event) }

    let(:event) do
      build(
        :event,
        :job_saved,
        data: {
          job_id: "A",
          employment_title: "Welder",
          employer_name: "Acme Inc.",
        }
      )
    end

    it "calls the Klayvio API" do
      expect_any_instance_of(Klayvio::Klayvio).to receive(:job_saved).with(
        email: event.data["email"],
        event_id: event.id,
        event_properties: {
          job_id: "A",
          employment_title: "Welder",
          employer_name: "Acme Inc.",
        },
        occurred_at: event.occurred_at,
      )

      subject
    end
  end
end