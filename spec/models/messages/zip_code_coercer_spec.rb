require 'rails_helper'

RSpec.describe Messages::ZipCodeCoercer do
  describe ".call" do
    subject { described_class.call(value) }

    context "when value is nil" do
      let(:value) { nil }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "when value is UNDEFINED" do
      let(:value) { Messages::UNDEFINED }

      it "returns UNDEFINED" do
        expect(subject).to eq(Messages::UNDEFINED)
      end
    end

    context "when value is an empty string" do
      let(:value) { "" }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "when value is a string" do
      let(:value) { "12345" }

      it "returns the value" do
        expect(subject).to eq(value)
      end
    end
  end
end
