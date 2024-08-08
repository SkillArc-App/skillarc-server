require 'rails_helper'

RSpec.describe PeopleSearch::PeopleAggregator do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject { instance.handle_message(message) }

    let(:instance) { described_class.new }

    context "person added" do
      let(:message) do
        build(
          :message,
          schema: Events::PersonAdded::V1,
          data: {
            first_name: "John",
            last_name: "Doe",
            email: "john.doe@skillarc.com",
            phone_number: "555-555-5555",
            date_of_birth: "1990-01-01"
          }
        )
      end

      it "creates a new person record" do
        expect { subject }.to change(PeopleSearch::Person, :count).from(0).to(1)

        person = PeopleSearch::Person.last

        expect(person.first_name).to eq("John")
        expect(person.last_name).to eq("Doe")
        expect(person.email).to eq("john.doe@skillarc.com")
        expect(person.phone_number).to eq("555-555-5555")
        expect(person.date_of_birth).to eq(Date.new(1990, 1, 1))
        expect(person.search_vector).to eq("John Doe john.doe@skillarc.com 555-555-5555 1990-01-01")
      end
    end

    context "basic info updated" do
      let(:person) { create(:people_search__person) }

      let(:message) do
        build(
          :message,
          schema: Events::BasicInfoAdded::V1,
          stream_id: person.id,
          data: {
            first_name: "Khushi",
            last_name: "Mo",
            phone_number: "999-999-9999",
            email: "khushi.mo@skillarc.com"
          }
        )
      end
      let(:person_id) { person.id }

      it "updates the person record" do
        subject

        person.reload

        expect(person.first_name).to eq("Khushi")
        expect(person.last_name).to eq("Mo")
        expect(person.phone_number).to eq("999-999-9999")
        expect(person.email).to eq("khushi.mo@skillarc.com")
        expect(person.search_vector).to eq("Khushi Mo khushi.mo@skillarc.com 999-999-9999 1990-01-01")
      end
    end

    context "coach assigned" do
      let(:message) do
        build(
          :message,
          schema: Events::CoachAssigned::V3,
          stream_id: person.id,
          data: {
            coach_id: SecureRandom.uuid
          }
        )
      end

      let(:person) { create(:people_search__person) }

      it "updates the assigned_coach_id field" do
        subject

        person.reload

        expect(person.assigned_coach_id).to eq(message.data.coach_id)
      end
    end

    context "attribute created" do
      let(:message) do
        build(
          :message,
          schema: Events::AttributeCreated::V2,
          stream_id: SecureRandom.uuid,
          data: {
            set: %w[cat dog]
          }
        )
      end

      it "creates an attribute for each value" do
        expect { subject }.to change(PeopleSearch::Attribute, :count).from(0).to(2)

        PeopleSearch::Attribute.find_by!(attribute_id: message.stream.id, value: "cat")
        PeopleSearch::Attribute.find_by!(attribute_id: message.stream.id, value: "dog")
      end
    end

    context "attribute updated" do
      let(:message) do
        build(
          :message,
          schema: Events::AttributeUpdated::V1,
          stream_id: attribute_id,
          data: {
            set: %w[cat dog]
          }
        )
      end

      let(:attribute_id) { SecureRandom.uuid }
      let!(:attribute1) { create(:people_search__attribute, attribute_id:, value: "parrot") }
      let!(:attribute2) { create(:people_search__attribute, attribute_id:, value: "cat") }

      it "creates new records and destroys records where needed" do
        expect { subject }.not_to change(PeopleSearch::Attribute, :count)

        existing = PeopleSearch::Attribute.find_by!(attribute_id: message.stream.id, value: "cat")
        expect(existing.id).to eq(attribute2.id)

        PeopleSearch::Attribute.find_by!(attribute_id: message.stream.id, value: "dog")
        expect(PeopleSearch::Attribute.find_by(attribute_id: message.stream.id, value: "parrot")).to eq(nil)
      end
    end

    context "attribute destroyed" do
      let(:message) do
        build(
          :message,
          schema: Events::AttributeDeleted::V1,
          stream_id: attribute_id
        )
      end

      let(:attribute_id) { SecureRandom.uuid }
      let!(:attribute1) { create(:people_search__attribute, attribute_id:, value: "parrot") }

      it "destroy all attributes associated with the id" do
        expect { subject }.to change(PeopleSearch::Attribute, :count).from(1).to(0)
      end
    end

    context "person attribute added" do
      let(:message) do
        build(
          :message,
          schema: Events::PersonAttributeAdded::V1,
          stream_id: person.id,
          data: {
            id:,
            attribute_id:,
            attribute_values: [attribute2.value]
          }
        )
      end

      let(:person) { attribute_person.person }
      let(:attribute_id) { SecureRandom.uuid }
      let(:id) { SecureRandom.uuid }
      let!(:attribute_person) { create(:people_search__attribute_person, id:, person_attribute: attribute1) }
      let!(:attribute1) { create(:people_search__attribute, attribute_id:, value: "cat") }
      let!(:attribute2) { create(:people_search__attribute, attribute_id:, value: "dog") }

      it "creates new records and destroys records where needed" do
        expect { subject }.not_to change(PeopleSearch::AttributePerson, :count)

        person.reload
        expect(person.person_attributes.length).to eq(1)
        expect(person.person_attributes[0]).to eq(attribute2)
      end
    end

    context "person attribute remove" do
      let(:message) do
        build(
          :message,
          schema: Events::PersonAttributeRemoved::V1,
          stream_id: person.id,
          data: {
            id:
          }
        )
      end

      let(:person) { attribute_person.person }
      let(:attribute_id) { SecureRandom.uuid }
      let(:id) { SecureRandom.uuid }
      let!(:attribute_person) { create(:people_search__attribute_person, id:) }

      it "destroys the attribute person records" do
        expect { subject }.to change(PeopleSearch::AttributePerson, :count).from(1).to(0)
      end
    end

    context "experience added" do
      let(:person) { create(:people_search__person) }

      let(:message) do
        build(
          :message,
          schema: Events::ExperienceAdded::V2,
          stream_id: person.id,
          data: {
            id:,
            organization_name: "Skillarc",
            position: "Software Engineer",
            start_date: "2019-01-01",
            end_date: "2021-01-01",
            description: "Worked on the backend team"
          }
        )
      end
      let(:id) { SecureRandom.uuid }

      it "creates adds a new experience record" do
        expect { subject }.to change(PeopleSearch::PersonExperience, :count).from(0).to(1)

        experience = PeopleSearch::PersonExperience.last

        expect(experience.organization_name).to eq("Skillarc")
        expect(experience.position).to eq("Software Engineer")
        expect(experience.description).to eq("Worked on the backend team")
      end

      it "updates the search vector" do
        subject

        person.reload

        expect(person.search_vector).to eq("John Doe john.doe@skillarc.com 555-555-5555 1990-01-01 Skillarc Software Engineer Worked on the backend team")
      end
    end

    context "experience removed" do
      let(:person) { create(:people_search__person) }
      let!(:experience) { create(:people_search__person_experience, person:) }
      let(:message) do
        build(
          :message,
          schema: Events::ExperienceRemoved::V2,
          stream_id: person.id,
          data: {
            id: experience.id
          }
        )
      end

      it "removes the experience record" do
        expect { subject }.to change(PeopleSearch::PersonExperience, :count).by(-1)
      end

      it "updates the search vector" do
        subject

        person.reload

        expect(person.search_vector).to eq("John Doe john.doe@skillarc.com 555-555-5555 1990-01-01")
      end
    end

    context "education experience added" do
      let(:person) { create(:people_search__person) }

      let(:message) do
        build(
          :message,
          schema: Events::EducationExperienceAdded::V2,
          stream_id: person.id,
          data: {
            id:,
            organization_name: "Skillarc University",
            title: "Bachelor of Science in Computer Science",
            activities: "Studied computer science",
            graduation_date: "2017-01-01"
          }
        )
      end
      let(:id) { SecureRandom.uuid }

      it "creates adds a new education experience record" do
        expect { subject }.to change(PeopleSearch::PersonEducationExperience, :count).by(1)
      end

      it "updates the search vector" do
        subject

        person.reload

        expected_vector =
          "John Doe john.doe@skillarc.com 555-555-5555 1990-01-01 Skillarc University Bachelor of Science in Computer Science Studied computer science"
        expect(person.search_vector).to eq(expected_vector)
      end
    end

    context "education experience removed" do
      let(:person) { create(:people_search__person) }
      let!(:education_experience) { create(:people_search__person_education_experience, person:) }

      let(:message) do
        build(
          :message,
          schema: Events::EducationExperienceDeleted::V2,
          stream_id: person.id,
          data: {
            id: education_experience.id
          }
        )
      end

      it "removes the education experience record" do
        expect { subject }.to change(PeopleSearch::PersonEducationExperience, :count).by(-1)
      end

      it "updates the search vector" do
        subject

        person.reload

        expect(person.search_vector).to eq("John Doe john.doe@skillarc.com 555-555-5555 1990-01-01")
      end
    end

    context "note added" do
      let(:person) { create(:people_search__person) }

      let(:message) do
        build(
          :message,
          schema: Events::NoteAdded::V4,
          stream_id: person.id,
          data: {
            originator: "foo",
            note: "This is a note",
            note_id: SecureRandom.uuid
          }
        )
      end
      let(:id) { SecureRandom.uuid }

      it "creates adds a new note record" do
        expect { subject }.to change(PeopleSearch::Note, :count).from(0).to(1)
      end

      it "updates the search vector" do
        subject

        person.reload

        expected_vector =
          "John Doe john.doe@skillarc.com 555-555-5555 1990-01-01 This is a note"
        expect(person.search_vector).to eq(expected_vector)
      end
    end

    context "note modified" do
      let(:person) { create(:people_search__person) }
      let(:note) { create(:people_search__note, person:) }

      let(:message) do
        build(
          :message,
          schema: Events::NoteModified::V4,
          stream_id: person.id,
          data: {
            originator: "foo",
            note: "This is an updated note",
            note_id: note.id
          }
        )
      end

      it "updates the search vector" do
        subject

        person.reload

        expected_vector =
          "John Doe john.doe@skillarc.com 555-555-5555 1990-01-01 This is an updated note"
        expect(person.search_vector).to eq(expected_vector)
      end
    end

    context "note deleted" do
      let(:person) { create(:people_search__person) }
      let!(:note) { create(:people_search__note, person:) }

      let(:message) do
        build(
          :message,
          schema: Events::NoteDeleted::V4,
          stream_id: person.id,
          data: {
            note_id: note.id
          }
        )
      end

      it "creates adds a new note record" do
        expect { subject }.to change(PeopleSearch::Note, :count).from(1).to(0)
      end

      it "updates the search vector" do
        subject

        person.reload

        expected_vector =
          "John Doe john.doe@skillarc.com 555-555-5555 1990-01-01"
        expect(person.search_vector).to eq(expected_vector)
      end
    end
  end
end
