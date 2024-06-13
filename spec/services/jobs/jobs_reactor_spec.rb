require 'rails_helper'

RSpec.describe Jobs::JobsReactor do
  it_behaves_like "a replayable message consumer"

  let(:message_service) { MessageService.new }
  let(:consumer) { described_class.new(message_service:) }

  describe "#create_job_attribute" do
    subject { consumer.create_job_attribute(job_id:, attribute_id:, acceptible_set:) }

    let(:job_id) { create(:job).id }
    let(:attribute) { create(:attributes_attribute, set: %w[A B]) }
    let(:attribute_id) { attribute.id }
    let(:acceptible_set) { %w[A] }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobAttributeCreated::V1,
        job_id:,
        data: {
          id: kind_of(String),
          attribute_name: attribute.name,
          attribute_id:,
          acceptible_set:
        }
      ).and_call_original

      subject
    end
  end

  describe "#update_job_attribute" do
    subject { consumer.update_job_attribute(job_id: job_attribute.job_id, job_attribute_id:, acceptible_set:) }

    let(:job_attribute) { create(:job_attribute, acceptible_set: %w[A B]) }
    let(:job_attribute_id) { job_attribute.id }
    let(:acceptible_set) { %w[A] }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobAttributeUpdated::V1,
        job_id: job_attribute.job_id,
        data: {
          id: job_attribute.id,
          acceptible_set:
        }
      ).and_call_original

      subject
    end
  end

  describe "#destroy_job_attribute" do
    subject { consumer.destroy_job_attribute(job_id: job_attribute.job_id, job_attribute_id:) }

    let(:job_attribute) { create(:job_attribute) }
    let(:job_attribute_id) { job_attribute.id }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobAttributeDestroyed::V1,
        job_id: job_attribute.job_id,
        data: {
          id: job_attribute.id
        }
      ).and_call_original

      subject
    end
  end

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    before do
      messages.each do |m|
        Event.from_message!(m)
      end
    end

    let(:messages) { [] }
    let(:aggregate) { Aggregates::Job.new(job_id:) }
    let(:id) { SecureRandom.uuid }
    let(:job_id) { SecureRandom.uuid }
    let(:master_certification_id) { SecureRandom.uuid }

    let(:job_created) do
      build(
        :message,
        aggregate:,
        schema: Events::JobCreated::V3,
        data: {
          category: Job::Categories::MARKETPLACE,
          employment_title: "A title",
          employer_name: "An employer",
          employer_id: SecureRandom.uuid,
          benefits_description: "Bad benifits",
          responsibilities_description: nil,
          location: "Columbus Ohio",
          employment_type: Job::EmploymentTypes::FULLTIME,
          hide_job: false
        }
      )
    end

    let(:desired_certification_created) do
      build(
        :message,
        aggregate:,
        schema: Events::DesiredCertificationCreated::V1,
        data: {
          id:,
          job_id:,
          master_certification_id:
        }
      )
    end

    context "when message is add desired certification" do
      let(:message) do
        build(
          :message,
          aggregate:,
          schema: Commands::AddDesiredCertification::V1,
          data: {
            id:,
            job_id:,
            master_certification_id:
          }
        )
      end

      context "when the job has not been created" do
        let(:messages) { [] }
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when the certification has already been added" do
        let(:messages) { [job_created, desired_certification_created] }
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when the certification has not already been added" do
        let(:messages) { [job_created] }

        it "emits a desired certification created event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              schema: Events::DesiredCertificationCreated::V1,
              data: {
                id: message.data.id,
                job_id: message.data.job_id,
                master_certification_id: message.data.master_certification_id
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end

    context "when message is remove desired certification" do
      let(:message) do
        build(
          :message,
          aggregate:,
          schema: Commands::RemoveDesiredCertification::V1,
          data: {
            id:
          }
        )
      end

      context "when the job has not been created" do
        let(:messages) { [] }
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when the certification has not already been added" do
        let(:messages) { [job_created] }
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when the certification has already been added" do
        let(:messages) { [job_created, desired_certification_created] }

        it "emits a desired certification deleted event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              schema: Events::DesiredCertificationDestroyed::V1,
              data: {
                id: message.data.id
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end
  end
end
