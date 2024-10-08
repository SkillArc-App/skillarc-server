require 'rails_helper'

RSpec.describe PeopleSearch::PeopleQuery do
  describe ".search" do
    subject do
      described_class.search(
        search_terms:,
        attributes:,
        user:,
        message_service:
      )
    end
    let(:message_service) { MessageService.new }
    let(:user) { create(:user) }
    let(:attribute_id1) { SecureRandom.uuid }
    let(:attribute_id2) { SecureRandom.uuid }

    let!(:attribute11) do
      create(
        :people_search__attribute,
        attribute_id: attribute_id1,
        attribute_value_id: dog
      )
    end
    let!(:attribute12) do
      create(
        :people_search__attribute,
        attribute_id: attribute_id1,
        attribute_value_id: cat
      )
    end
    let!(:attribute21) do
      create(
        :people_search__attribute,
        attribute_id: attribute_id2,
        attribute_value_id: red
      )
    end
    let!(:attribute22) do
      create(
        :people_search__attribute,
        attribute_id: attribute_id2,
        attribute_value_id: blue
      )
    end

    let(:red) { SecureRandom.uuid }
    let(:blue) { SecureRandom.uuid }
    let(:dog) { SecureRandom.uuid }
    let(:cat) { SecureRandom.uuid }

    let!(:person1) do
      create(
        :people_search__person,
        search_vector: "John Chabot 555-555-5555 john.chabot@skillarc.com"
      )
    end
    let!(:person2) do
      create(
        :people_search__person,
        search_vector: "Some One 333-333-3333 Else"
      )
    end
    let!(:person3) do
      create(
        :people_search__person,
        search_vector: "Another Person 444-444-4444 Else"
      )
    end

    before do
      create(
        :people_search__attribute_person,
        person: person1,
        person_attribute: attribute11
      )
      create(
        :people_search__attribute_person,
        person: person1,
        person_attribute: attribute22
      )
      create(
        :people_search__attribute_person,
        person: person2,
        person_attribute: attribute22
      )
    end

    context "when only search terms are provided" do
      let(:search_terms) { "john chabot" }
      let(:attributes) { {} }

      it "returns a list of people" do
        expect(subject).to contain_exactly(person1.id)
      end

      it "emits an event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Users::Events::PersonSearchExecuted::V3,
            user_id: user.id,
            data: {
              search_terms:,
              attributes: []
            }
          ).and_call_original

        subject
      end
    end

    context "when attributes are provided" do
      let(:search_terms) { nil }
      let(:attributes) do
        {
          attribute_id1 => [dog, cat],
          attribute_id2 => [blue]
        }
      end

      it "returns a list of people" do
        expect(subject).to contain_exactly(person1.id)
      end

      it "emits an event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Users::Events::PersonSearchExecuted::V3,
            user_id: user.id,
            data: {
              search_terms:,
              attributes: [
                Users::Events::PersonSearchExecuted::Attribute::V1.new(
                  id: attribute_id1,
                  values: [dog, cat]
                ),
                Users::Events::PersonSearchExecuted::Attribute::V1.new(
                  id: attribute_id2,
                  values: [blue]
                )
              ]
            }
          ).and_call_original

        subject
      end
    end

    context "when attributes and terms are are provided" do
      let(:search_terms) { "John" }
      let(:attributes) do
        {
          attribute_id2 => [blue]
        }
      end

      it "returns a list of people" do
        expect(subject).to contain_exactly(person1.id)
      end

      it "emits an event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Users::Events::PersonSearchExecuted::V3,
            user_id: user.id,
            data: {
              search_terms:,
              attributes: [
                Users::Events::PersonSearchExecuted::Attribute::V1.new(
                  id: attribute_id2,
                  values: [blue]
                )
              ]
            }
          ).and_call_original

        subject
      end
    end
  end
end
