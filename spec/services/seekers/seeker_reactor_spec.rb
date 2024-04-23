require 'rails_helper'

RSpec.describe Seekers::SeekerReactor do
  it_behaves_like "a message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }

  describe "add_education_experience" do
    subject do
      consumer.add_education_experience(
        seeker_id:,
        organization_name:,
        title:,
        graduation_date:,
        gpa:,
        activities:,
        trace_id:,
        id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:organization_name) { "Some org" }
    let(:title) { "Scholar" }
    let(:graduation_date) { "Some date" }
    let(:gpa) { "3.9" }
    let(:activities) { "Picking my nose" }
    let(:trace_id) { SecureRandom.uuid }
    let(:id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::EducationExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id:,
            activities:,
            organization_name:,
            title:,
            graduation_date:,
            gpa:
          }
        )

      subject
    end
  end

  describe "remove_education_experience" do
    subject do
      consumer.remove_education_experience(
        seeker_id:,
        education_experience_id:,
        trace_id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:education_experience_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::EducationExperienceDeleted::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: education_experience_id
          }
        )

      subject
    end
  end

  describe "add_personal_experience" do
    subject do
      consumer.add_personal_experience(
        seeker_id:,
        activity:,
        description:,
        start_date:,
        end_date:,
        trace_id:,
        id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:activity) { "Do stuff" }
    let(:description) { "Best stuff" }
    let(:start_date) { "bro" }
    let(:end_date) { "15" }
    let(:trace_id) { SecureRandom.uuid }
    let(:id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::PersonalExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id:,
            activity:,
            description:,
            start_date:,
            end_date:
          }
        )

      subject
    end
  end

  describe "remove_personal_experience" do
    subject do
      consumer.remove_personal_experience(
        seeker_id:,
        personal_experience_id:,
        trace_id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:personal_experience_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::PersonalExperienceRemoved::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: personal_experience_id
          }
        )

      subject
    end
  end

  describe "add_experience" do
    subject do
      consumer.add_experience(
        seeker_id:,
        organization_name:,
        position:,
        start_date:,
        end_date:,
        is_current:,
        description:,
        trace_id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:organization_name) { "Some org" }
    let(:position) { "Best position" }
    let(:start_date) { "2000-10-25" }
    let(:end_date) { "2005-3-25" }
    let(:is_current) { true }
    let(:description) { "It was a great job" }
    let(:trace_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::ExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: be_a(String),
            organization_name:,
            position:,
            start_date:,
            end_date:,
            description:,
            is_current:
          }
        )

      subject
    end
  end

  describe "remove_experience" do
    subject do
      consumer.remove_experience(
        seeker_id:,
        experience_id:,
        trace_id:
      )
    end

    let(:seeker_id) { SecureRandom.uuid }
    let(:experience_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::ExperienceRemoved::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: experience_id
          }
        )

      subject
    end
  end

  describe "#handle_message" do
    subject { consumer.handle_message(message) }
  end
end
