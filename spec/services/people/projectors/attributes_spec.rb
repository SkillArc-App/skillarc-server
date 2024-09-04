require 'rails_helper'

RSpec.describe People::Projectors::Attributes do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:stream) { People::Streams::Person.new(person_id:) }
    let(:person_id) { SecureRandom.uuid }
    let(:id1) { SecureRandom.uuid }
    let(:id2) { SecureRandom.uuid }
    let(:dog) { SecureRandom.uuid }
    let(:cat) { SecureRandom.uuid }
    let(:parrot) { SecureRandom.uuid }
    let(:girl) { SecureRandom.uuid }
    let(:boy) { SecureRandom.uuid }

    let(:person_attribute_added1) do
      build(
        :message,
        stream:,
        schema: People::Events::PersonAttributeAdded::V2,
        data: {
          id: id1,
          attribute_value_ids: [cat, dog]
        }
      )
    end
    let(:person_attribute_added2) do
      build(
        :message,
        stream:,
        schema: People::Events::PersonAttributeAdded::V2,
        data: {
          id: id1,
          attribute_value_ids: [parrot, dog]
        }
      )
    end
    let(:person_attribute_added3) do
      build(
        :message,
        stream:,
        schema: People::Events::PersonAttributeAdded::V2,
        data: {
          id: id2,
          attribute_value_ids: [girl, boy]
        }
      )
    end
    let(:person_attribute_removed) do
      build(
        :message,
        stream:,
        schema: People::Events::PersonAttributeRemoved::V1,
        data: {
          id: id2
        }
      )
    end

    let(:messages) { [person_attribute_added1, person_attribute_added2, person_attribute_added3, person_attribute_removed] }

    it "determines the first and last name" do
      expect(subject.attributes.length).to eq(1)
      expect(subject.attributes[id1]).to eq(described_class::PersonAttribute.new(
                                              id: person_attribute_added2.data.attribute_id,
                                              attribute_value_ids: person_attribute_added2.data.attribute_value_ids
                                            ))
    end
  end
end
