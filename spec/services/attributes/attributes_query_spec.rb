require 'rails_helper'

RSpec.describe Attributes::AttributesQuery do
  describe ".all" do
    subject { described_class.all }

    let!(:attribute) { create(:attributes_attribute) }

    it "returns all attributes" do
      expect(subject).to eq(Attributes::Attribute.all)
    end
  end
end
