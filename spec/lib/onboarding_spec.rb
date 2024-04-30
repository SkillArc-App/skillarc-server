require 'rails_helper'

RSpec.describe Onboarding do
  let(:message_service) { MessageService.new }
  let(:user_id) { SecureRandom.uuid }
  let(:seeker_id) { SecureRandom.uuid }
  let(:trace_id) { SecureRandom.uuid }

  describe "#update" do
    subject { described_class.new(message_service:, seeker_id:, user_id:, trace_id:).update(responses:) }

    context "when the responses include name" do
      let(:responses) do
        {
          "name" => {
            "response" => {
              "first_name" => "John",
              "last_name" => "Doe",
              "phone_number" => "1234567890",
              "date_of_birth" => "01/01/2000"
            }
          }
        }
      end

      it "publishes an event" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            schema: Events::BasicInfoAdded::V1,
            trace_id:,
            data: {
              first_name: "John",
              last_name: "Doe",
              phone_number: "1234567890",
              user_id:,
              date_of_birth: Date.new(2000, 1, 1)
            }
          ).and_call_original

        subject
      end
    end

    context "when the responses include experience" do
      let(:responses) do
        {
          "experience" => {
            "response" => [{
              "company" => "Company",
              "position" => "Position",
              "start_date" => "01/01/2000",
              "current" => true,
              "end_date" => nil,
              "description" => "Description"
            }]
          }
        }
      end

      it "publishes an event" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            trace_id:,
            schema: Events::ExperienceAdded::V1,
            data: {
              id: be_present,
              organization_name: "Company",
              position: "Position",
              start_date: "01/01/2000",
              is_current: true,
              end_date: nil,
              description: "Description"
            }
          ).and_call_original

        subject
      end
    end

    context "when the responses include education" do
      let(:responses) do
        {
          "education" => {
            "response" => [{
              "activities" => "Football",
              "org" => "School",
              "title" => "Title",
              "grad_year" => "2000",
              "gpa" => "4.0"
            }]
          }
        }
      end

      it "publishes an event" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            trace_id:,
            schema: Events::EducationExperienceAdded::V1,
            data: {
              id: be_present,
              activities: "Football",
              organization_name: "School",
              title: "Title",
              graduation_date: "2000",
              gpa: "4.0"
            }
          ).and_call_original

        subject
      end
    end

    context "when the responses include training_provider" do
      let(:responses) do
        {
          "training_provider" => {
            "response" => [
              training_provider_id
            ]
          }
        }
      end
      let(:training_provider_id) { SecureRandom.uuid }

      it "publishes an event" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            trace_id:,
            schema: Events::SeekerTrainingProviderCreated::V2,
            data: {
              id: be_present,
              user_id:,
              training_provider_id:
            }
          ).and_call_original

        subject
      end
    end

    context "when the responses include opportunity_interests" do
      let(:responses) do
        {
          "opportunity_interests" => {
            "response" => ["construction"]
          }
        }
      end

      it "publishes an event" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            trace_id:,
            schema: Events::ProfessionalInterests::V1,
            data: {
              interests: ["construction"]
            }
          ).and_call_original

        subject
      end
    end

    context "when the responses include other" do
      let(:responses) do
        {
          "other" => {
            "response" => [{
              "activity" => "Activity",
              "start_date" => "01/01/2000",
              "end_date" => "01/01/2001",
              "learning" => "Learning"
            }]
          }
        }
      end

      it "publishes an event" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            trace_id:,
            schema: Events::PersonalExperienceAdded::V1,
            data: {
              id: be_present,
              activity: "Activity",
              start_date: "01/01/2000",
              end_date: "01/01/2001",
              description: "Learning"
            }
          ).and_call_original

        subject
      end
    end

    context "when the responses include reliability" do
      context "when all responses are given" do
        let(:responses) do
          {
            "reliability" => {
              "response" => [
                "I've had or currently have a job",
                'I have a High School Diploma / GED',
                "I've attended a Training Program"
              ]
            }
          }
        end

        it "publishes an event" do
          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              seeker_id:,
              trace_id:,
              schema: Events::ReliabilityAdded::V1,
              data: {
                reliabilities: [Reliability::JOB, Reliability::EDUCATION, Reliability::TRAINING_PROGRAM]
              }
            ).and_call_original

          subject
        end
      end
    end

    context "when there are repetitive responses" do
      let(:responses1) do
        {
          "name" => {
            "response" => {
              "first_name" => "John",
              "last_name" => "Doe",
              "phone_number" => "1234567890",
              "date_of_birth" => "01/01/2000"
            }
          }
        }
      end
      let(:responses2) do
        {
          "name" => {
            "response" => {
              "first_name" => "John",
              "last_name" => "Doe",
              "phone_number" => "1234567890",
              "date_of_birth" => "01/01/2000"
            }
          }
        }
      end

      it "emits two events" do
        expect_any_instance_of(MessageService)
          .to receive(:create!)
          .with(
            seeker_id:,
            trace_id:,
            schema: Events::BasicInfoAdded::V1,
            data: {
              first_name: "John",
              last_name: "Doe",
              phone_number: "1234567890",
              date_of_birth: Date.new(2000, 1, 1),
              user_id:
            }
          )
          .twice
          .and_call_original

        onboarding = described_class.new(message_service:, seeker_id:, user_id:, trace_id:)

        onboarding.update(responses: responses1)
        onboarding.update(responses: responses2)
      end
    end
  end
end
