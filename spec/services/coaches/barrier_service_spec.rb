require "rails_helper"

RSpec.describe Coaches::BarrierService do
  let(:barrier_added) do
    build(
      :events__message,
      :barrier_added,
      aggregate_id: "coaches",
      data: Events::Common::UntypedHashWrapper.new(
        barrier_id:,
        name: "barrier name"
      )
    )
  end
  let(:barrier_id) { SecureRandom.uuid }

  it_behaves_like "an event consumer"

  before do
    described_class.handle_event(barrier_added)
  end

  describe ".all" do
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

  describe ".reset_for_replay" do
    it "destroys all records" do
      expect(Barrier.count).not_to eq(0)

      described_class.reset_for_replay

      expect(Barrier.count).to eq(0)
    end
  end
end
