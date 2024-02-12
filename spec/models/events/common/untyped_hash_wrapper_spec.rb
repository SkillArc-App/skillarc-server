require 'rails_helper'

RSpec.describe Events::Common::UntypedHashWrapper do
  describe "#[]" do
    subject do
      instance
    end

    let(:instance) do
      described_class.new(hash)
    end
    let(:hash) do
      {
        cat: 10,
        dog: 3,
        nested: { inner: [] }
      }
    end

    it "indexes the hash" do
      expect(subject[:cat]).to eq(10)
      expect(subject[:dog]).to eq(3)
    end
  end

  describe "#to_h" do
    subject do
      instance.to_h
    end

    let(:instance) do
      described_class.new(hash)
    end
    let(:hash) do
      {
        cat: 10,
        dog: 3,
        nested: { inner: [] }
      }
    end

    it "returns cloned hash" do
      expect(subject).to eq(hash)
      expect(subject.object_id).to_not eq(hash.object_id)
    end
  end

  describe ".from_hash" do
    subject do
      described_class.from_hash(hash)
    end

    let(:hash) do
      {
        cat: 10,
        dog: 3,
        nested: { inner: [] }
      }
    end

    it "returns cloned hash" do
      expect(subject).to be_a(described_class)
      expect(subject.to_h).to eq(hash)
    end
  end

  describe "#==" do
    let(:hash1) { { cat: 1 } }
    let(:hash2) { { cat: 1 } }
    let(:hash3) { { cat: 2 } }

    context "when the base hashs are value equal" do
      it "returns true" do
        expect(described_class.new(hash1)).to eq(described_class.new(hash2))
      end
    end

    context "when the base hashs are not value equal" do
      it "return false" do
        expect(described_class.new(hash2)).not_to eq(described_class.new(hash3))
      end
    end
  end
end
