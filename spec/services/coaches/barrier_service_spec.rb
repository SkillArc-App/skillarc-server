require "rails_helper"

RSpec.describe Coaches::BarrierService do
  let(:barrier_added) do
    build(
      :message,
      :barrier_added,
      aggregate_id: "coaches",
      data: Events::BarrierAdded::Data::V1.new(
        barrier_id:,
        name: "barrier name"
      )
    )
  end
  let(:barrier_id) { SecureRandom.uuid }
  let(:consumer) { described_class.new }

  it_behaves_like "a message consuemr"

  before do
    consumer.handle_message(barrier_added)
  end

  describe ".all" do
    subject { consumer.all }

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

      consumer.reset_for_replay

      expect(Barrier.count).to eq(0)
    end
  end
end
