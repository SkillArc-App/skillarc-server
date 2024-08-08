require 'rails_helper'

RSpec.describe Attributes::AttributesQuery do
  describe ".all" do
    subject { described_class.all }

    let!(:attribute) { create(:attributes_attribute) }

    it "returns all attributes" do
      expect(subject).to eq([{
        id: attribute.id,
        default: attribute.default,
        description: attribute.description,
        machine_derived: attribute.machine_derived,
        name: attribute.name,
        set: attribute.set,
      }])
    end
  end

  describe ".find" do
    subject { described_class.find(attribute_id) }

    let!(:attribute) { create(:attributes_attribute) }
    let(:attribute_id) { attribute.id }

    it "returns the attribute" do
      expect(subject).to eq({
        id: attribute.id,
        default: attribute.default,
        description: attribute.description,
        machine_derived: attribute.machine_derived,
        name: attribute.name,
        set: attribute.set,
      })
    end
  end
end
