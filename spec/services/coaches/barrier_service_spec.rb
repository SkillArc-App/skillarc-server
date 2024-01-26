require "rails_helper"

RSpec.describe Coaches::BarrierService do
  let(:barrier_added) do
    build(
      :event_message,
      :barrier_added,
      aggregate_id: "coaches",
      data: {
        barrier_id:,
        name: "barrier name"
      }
    )
  end
  let(:barrier_id) { SecureRandom.uuid }

  describe ".all" do
    before do
      described_class.handle_event(barrier_added)
    end

    subject { described_class.all }

    it "returns all barriers" do
      expect(subject).to contain_exactly(
        {
          id: barrier_id,
          name: "barrier name"
        }
      )
    end
  end
end
