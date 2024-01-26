require 'rails_helper'

RSpec.describe Events::Common::UntypedHashWrapper do
  describe "#to_h" do
    subject do
      instance.to_h
    end

    let(:instance) do
      described_class.new(
        cat: 10,
        dog: 3,
        nested: { "inner": [] }
      )
    end

    it "returns a deeply symbolized hash" do
      expect(subject).to eq({ cat: 10, dog: 3, nested: { inner: [] } })
    end
  end
end
