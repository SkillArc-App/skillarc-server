require 'rails_helper'

RSpec.describe Attributes::Projectors::CurrentState do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:stream) { Attributes::Streams::Attribute.new(attribute_id: SecureRandom.uuid) }
    let(:cat_id) { SecureRandom.uuid }
    let(:dog_id) { SecureRandom.uuid }
    let(:horse_id) { SecureRandom.uuid }

    let(:created) do
      build(
        :message,
        stream:,
        schema: Attributes::Events::Created::V4,
        data: {
          set: [
            Core::UuidKeyValuePair.new(key: cat_id, value: "cat"),
            Core::UuidKeyValuePair.new(key: dog_id, value: "dog")
          ]
        }
      )
    end
    let(:updated) do
      build(
        :message,
        stream:,
        schema: Attributes::Events::Updated::V3,
        data: {
          set: [
            Core::UuidKeyValuePair.new(key: horse_id, value: "horse"),
            Core::UuidKeyValuePair.new(key: dog_id, value: "dog")
          ]
        }
      )
    end
    let(:deleted) do
      build(
        :message,
        stream:,
        schema: Attributes::Events::Deleted::V2
      )
    end

    context "when updated" do
      let(:messages) { [created, updated] }

      it "determines the current state" do
        expect(subject.set.length).to eq(2)
        expect(subject.set[0]).to eq(Core::UuidKeyValuePair.new(key: horse_id, value: "horse"))
        expect(subject.set[1]).to eq(Core::UuidKeyValuePair.new(key: dog_id, value: "dog"))
      end
    end

    context "when deleted" do
      let(:messages) { [created, deleted] }

      it "determines the current state" do
        expect(subject.set.length).to eq(0)
      end
    end
  end
end
