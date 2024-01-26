require 'rails_helper'

RSpec.describe Events::Common::Nothing do
  describe ".===" do
    it "is case equal to itself" do
      expect(described_class === described_class).to eq(true)
    end
  end

  describe ".to_h" do
    subject do
      described_class.to_h
    end

    it "returns a empty hash" do
      expect(subject).to eq({})
    end
  end
end
