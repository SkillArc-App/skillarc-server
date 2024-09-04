require 'rails_helper'

RSpec.describe JobOrders::CriteriaMetReactor do
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:trace_id) { SecureRandom.uuid }
  let(:job_order_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }
  let(:job_stream) { Jobs::Streams::Job.new(job_id:) }
  let(:person_id) { SecureRandom.uuid }
  let(:job_order_stream) { JobOrders::Streams::JobOrder.new(job_order_id: SecureRandom.uuid) }

  describe "#handle_message" do
    subject { instance.handle_message(message) }

    before do
      messages.each do |message|
        Event.from_message!(message)
      end
    end

    let(:messages) { [] }

    shared_examples "emits criteria met event if necessary" do
      context "when possible to criteria met" do
        before do
          allow(MessageService)
            .to receive(:stream_events)
            .and_call_original

          expect(MessageService)
            .to receive(:stream_events)
            .with(job_stream)
            .and_return(job_messages)

          expect_any_instance_of(JobOrders::Projectors::JobOrderCriteriaMet)
            .to receive(:project)
            .with(job_messages)
            .and_return(met)
        end

        let(:message1) do
          build(
            :message,
            schema: Jobs::Events::JobCreated::V3,
            stream: job_stream,
            data: {
              category: Job::Categories::STAFFING,
              employment_title: "Plumber",
              employer_name: "Good Employer",
              employer_id: SecureRandom.uuid,
              benefits_description: "Great Benifits",
              location: "Columbus, OH",
              employment_type: Job::EmploymentTypes::FULLTIME,
              hide_job: false,
              industry: nil
            }
          )
        end
        let(:message2) do
          build(
            :message,
            schema: Jobs::Events::JobAttributeCreated::V2,
            stream: job_stream,
            data: {
              job_attribute_id: SecureRandom.uuid,
              attribute_id: SecureRandom.uuid,
              acceptible_set: [cat, dog]
            }
          )
        end
        let(:message3) do
          build(
            :message,
            schema: JobOrders::Events::Added::V1,
            stream: job_order_stream,
            data: {
              job_id: job_stream.id
            }
          )
        end
        let(:message4) do
          build(
            :message,
            schema: JobOrders::Events::Added::V1,
            stream: job_order_stream,
            data: {
              job_id: SecureRandom.uuid
            }
          )
        end

        let(:cat) { SecureRandom.uuid }
        let(:dog) { SecureRandom.uuid }
        let(:parrot) { SecureRandom.uuid }
        let(:bunny) { SecureRandom.uuid }
        let(:job_messages) { [message1, message2] }
        let(:messages) { [message1, message2, message3, message4] }

        context "when the criteria is met" do
          let(:met) { true }

          it "does not emit a new message" do
            expect(message_service)
              .to receive(:create_once_for_stream!)
              .with(
                schema: JobOrders::Events::CriteriaAdded::V1,
                trace_id: message.trace_id,
                stream: message3.stream,
                data: Core::Nothing
              )
              .and_call_original

            subject
          end
        end

        context "when the criteria is not met" do
          let(:met) { false }
          let(:message_service) { double }

          it "does nothing" do
            subject
          end
        end
      end
    end

    context "when the message is job order added" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Events::Added::V1,
          data: {
            job_id:
          }
        )
      end

      it_behaves_like "emits criteria met event if necessary"
    end

    context "when the message is job updated" do
      let(:message) do
        build(
          :message,
          schema: Jobs::Events::JobCreated::V3,
          stream: job_stream,
          data: {
            category: Job::Categories::STAFFING,
            employment_title: "Another title",
            employment_type: Job::EmploymentTypes::PARTTIME,
            hide_job: false
          }
        )
      end

      it_behaves_like "emits criteria met event if necessary"
    end

    context "when the message is job attribute created" do
      let(:message) do
        build(
          :message,
          schema: Jobs::Events::JobAttributeCreated::V2,
          stream: job_stream,
          data: {
            job_attribute_id: SecureRandom.uuid,
            attribute_id: SecureRandom.uuid,
            acceptible_set: [cat, dog]
          }
        )
      end

      it_behaves_like "emits criteria met event if necessary"
    end

    context "when the message is job attribute updated" do
      let(:message) do
        build(
          :message,
          schema: Jobs::Events::JobAttributeUpdated::V2,
          stream: job_stream,
          data: {
            job_attribute_id: SecureRandom.uuid,
            acceptible_set: [parrot, bunny]
          }
        )
      end

      it_behaves_like "emits criteria met event if necessary"
    end

    context "when the message is job attribute destroyed" do
      let(:message) do
        build(
          :message,
          schema: Jobs::Events::JobAttributeDestroyed::V2,
          stream: job_stream,
          data: {
            job_attribute_id: SecureRandom.uuid
          }
        )
      end

      it_behaves_like "emits criteria met event if necessary"
    end
  end
end
