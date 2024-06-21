require 'rails_helper'

RSpec.describe People::Projectors::Name do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:aggregate) { Aggregates::Person.new(person_id:) }
    let(:person_id) { SecureRandom.uuid }

    let(:person_added) do
      build(
        :message,
        aggregate:,
        schema: Events::PersonAdded::V1,
        data: {
          email: SecureRandom.uuid,
          phone_number: nil,
          first_name: "Some",
          last_name: "Body",
          date_of_birth: nil
        }
      )
    end
    let(:basic_info_added) do
      build(
        :message,
        aggregate:,
        schema: Events::BasicInfoAdded::V1,
        data: {
          email: nil,
          first_name: "So",
          last_name: "Bod",
          phone_number: "333-333-3333"
        }
      )
    end

    let(:messages) { [person_added, basic_info_added] }

    it "determines the first and last name" do
      expect(subject.first_name).to eq(basic_info_added.data.first_name)
      expect(subject.last_name).to eq(basic_info_added.data.last_name)
    end
  end
end
