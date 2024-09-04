require 'rails_helper'

RSpec.describe Attributes::AttributesAggregator do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new }

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    let(:id_a) { SecureRandom.uuid }
    let(:id_b) { SecureRandom.uuid }

    context "AttributeCreated" do
      let(:message) do
        build(
          :message,
          schema: Attributes::Events::Created::V4,
          data: {
            name: "name",
            description: "description",
            set: [
              Core::UuidKeyValuePair.new(
                key: id_a,
                value: "A"
              ),
              Core::UuidKeyValuePair.new(
                key: id_b,
                value: "B"
              )
            ],
            default: [
              Core::UuidKeyValuePair.new(
                key: id_b,
                value: "B"
              )
            ],
            machine_derived: true
          }
        )
      end

      it "creates an attribute" do
        expect { subject }.to change(Attributes::Attribute, :count).from(0).to(1)

        attribute = Attributes::Attribute.first
        expect(attribute.name).to eq(message.data.name)
        expect(attribute.description).to eq(message.data.description)
        expect(attribute.set).to eq({ id_a => "A", id_b => "B" })
        expect(attribute.default).to eq({ id_b => "B" })
        expect(attribute.machine_derived).to eq(message.data.machine_derived)
      end
    end

    context "AttributeUpdated" do
      let(:message) do
        build(
          :message,
          schema: Attributes::Events::Updated::V3,
          stream_id: attribute.id,
          data: {
            name: "name",
            description: "description",
            set: [
              Core::UuidKeyValuePair.new(
                key: id_a,
                value: "A"
              ),
              Core::UuidKeyValuePair.new(
                key: id_b,
                value: "B"
              )
            ],
            default: [
              Core::UuidKeyValuePair.new(
                key: id_b,
                value: "B"
              )
            ]
          }
        )
      end

      let!(:attribute) { create(:attributes_attribute) }

      it "updates an attribute" do
        subject

        attribute.reload
        expect(attribute.name).to eq(message.data.name)
        expect(attribute.description).to eq(message.data.description)
        expect(attribute.set).to eq({ id_a => "A", id_b => "B" })
        expect(attribute.default).to eq({ id_b => "B" })
      end
    end

    context "AttributeDeleted" do
      let(:message) do
        build(
          :message,
          schema: Attributes::Events::Deleted::V2,
          stream_id: attribute.id
        )
      end

      let!(:attribute) { create(:attributes_attribute) }

      it "deletes an attribute" do
        expect { subject }.to change { Attributes::Attribute.count }.by(-1)
      end
    end
  end
end
