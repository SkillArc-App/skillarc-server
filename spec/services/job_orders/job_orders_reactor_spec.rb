require 'rails_helper'

RSpec.describe JobOrders::JobOrdersReactor do # rubocop:disable Metrics/BlockLength
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:trace_id) { SecureRandom.uuid }
  let(:job_order_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }

  describe "#add_order_count" do
    subject do
      instance.add_order_count(job_order_id:, order_count:, trace_id:)
    end

    let(:job_order_id) { 10 }
    let(:order_count) { 10 }

    it "fires off a job order order count added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: JobOrders::Events::OrderCountAdded::V1,
          job_order_id:,
          trace_id:,
          data: {
            order_count:
          }
        )

      subject
    end
  end

  describe "#close_job_order_not_filled" do
    subject do
      instance.close_job_order_not_filled(job_order_id:, trace_id:)
    end

    let(:job_order_id) { 10 }

    it "fires off a job order order activated event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: JobOrders::Events::NotFilled::V1,
          job_order_id:,
          trace_id:,
          data: Core::Nothing
        )

      subject
    end
  end

  describe "#add_note" do
    subject do
      instance.add_note(
        job_order_id:,
        originator:,
        note:,
        note_id:,
        trace_id:
      )
    end

    let(:job_order_id) { 10 }
    let(:originator) { "hannah@skillar.com" }
    let(:note) { "Great job order" }
    let(:note_id) { SecureRandom.uuid }

    it "fires off a job order note added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: JobOrders::Events::NoteAdded::V1,
          job_order_id:,
          trace_id:,
          data: {
            originator:,
            note:,
            note_id:
          }
        )

      subject
    end
  end

  describe "#modify_note" do
    subject do
      instance.modify_note(
        job_order_id:,
        originator:,
        note:,
        note_id:,
        trace_id:
      )
    end

    let(:job_order_id) { 10 }
    let(:originator) { "hannah@skillar.com" }
    let(:note) { "Great job order" }
    let(:note_id) { SecureRandom.uuid }

    it "fires off a job order note added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: JobOrders::Events::NoteModified::V1,
          job_order_id:,
          trace_id:,
          data: {
            originator:,
            note:,
            note_id:
          }
        )

      subject
    end
  end

  describe "#remove_note" do
    subject do
      instance.remove_note(
        job_order_id:,
        originator:,
        note_id:,
        trace_id:
      )
    end

    let(:job_order_id) { 10 }
    let(:originator) { "hannah@skillar.com" }
    let(:note_id) { SecureRandom.uuid }

    it "fires off a job order note added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: JobOrders::Events::NoteRemoved::V1,
          job_order_id:,
          trace_id:,
          data: {
            originator:,
            note_id:
          }
        )

      subject
    end
  end

  describe "#update_status" do
    subject do
      instance.update_status(status:, job_order_id:, person_id:, trace_id:)
    end

    let(:candidate) { create(:job_orders__candidate) }
    let(:person_id) { candidate.person_id }
    let(:job_order_id) { candidate.job_order_id }

    context "added" do
      let(:status) { "added" }

      it "emits a added event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: JobOrders::Events::CandidateAdded::V2,
            job_order_id:,
            trace_id:,
            data: {
              person_id:
            }
          ).and_call_original

        subject
      end
    end

    context "recommended" do
      let(:status) { "recommended" }

      it "emits a recommended event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: JobOrders::Events::CandidateRecommended::V2,
            job_order_id:,
            trace_id:,
            data: {
              person_id:
            }
          ).and_call_original

        subject
      end
    end

    context "hired" do
      let(:status) { "hired" }

      it "emits a hired event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: JobOrders::Events::CandidateHired::V2,
            job_order_id:,
            trace_id:,
            data: {
              person_id:
            }
          ).and_call_original

        subject
      end
    end

    context "rescinded" do
      let(:status) { "rescinded" }

      it "emits a rescinded event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: JobOrders::Events::CandidateRescinded::V2,
            job_order_id:,
            trace_id:,
            data: {
              person_id:
            }
          ).and_call_original

        subject
      end
    end
  end

  describe "#handle_message" do # rubocop:disable Metrics/BlockLength
    subject { instance.handle_message(message) }

    context "when the message is job created" do
      let(:message) do
        build(
          :message,
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

      it "emits a JobOrderAdded event" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: JobOrders::Events::Added::V1,
            job_order_id: be_a(String),
            trace_id: message.trace_id,
            data: {
              job_id: message.aggregate.id
            }
          )

        subject
      end
    end

    context "when the message is applicant status updated" do
      let(:message) do
        build(
          :message,
          schema: Events::ApplicantStatusUpdated::V6,
          data: {
            applicant_first_name: "first_name",
            applicant_last_name: "last_name",
            applicant_email: "email",
            applicant_phone_number: "phone_number",
            seeker_id: person_id,
            user_id: "user_id",
            job_id:,
            employer_name: "employer_name",
            employment_title: "employment_title",
            status:,
            reasons: []
          },
          metadata: {}
        )
      end

      let(:person_id) { SecureRandom.uuid }
      let(:job_id) { SecureRandom.uuid }

      context "when status is not new" do
        let(:status) { ApplicantStatus::StatusTypes::INTERVIEWING }

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create_once_for_trace!)

          subject
        end
      end

      context "when status is new" do
        before do
          messages.each do |message|
            Event.from_message!(message)
          end
        end

        let(:status) { ApplicantStatus::StatusTypes::NEW }

        context "when there is not a job order for the job_id" do
          let(:messages) { [] }

          it "does nothing" do
            expect(message_service)
              .not_to receive(:create_once_for_trace!)

            subject
          end
        end

        context "when there are job orders for the job_id" do
          let(:messages) { [job_order1, job_order1_closed, job_order2] }

          let(:job_order1) do
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            )
          end
          let(:job_order1_closed) do
            build(
              :message,
              aggregate: job_order1.aggregate,
              schema: JobOrders::Events::NotFilled::V1,
              occurred_at: Time.zone.local(2019, 6, 1),
              data: Core::Nothing
            )
          end
          let(:job_order2) do
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              occurred_at: Time.zone.local(2020, 1, 1),
              data: {
                job_id:
              }
            )
          end

          it "emits the relevants messages" do
            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: JobOrders::Events::CandidateAdded::V2,
                trace_id: message.trace_id,
                aggregate: job_order2.aggregate,
                data: {
                  person_id:
                }
              )
              .and_call_original

            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: JobOrders::Events::CandidateApplied::V2,
                trace_id: message.trace_id,
                aggregate: job_order2.aggregate,
                data: {
                  person_id:,
                  applied_at: message.occurred_at
                }
              )
              .and_call_original

            subject
          end
        end
      end
    end

    context "when the message is add job order" do
      before do
        messages.each do |message|
          Event.from_message!(message)
        end
      end

      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::Add::V1,
          aggregate:,
          data: {
            job_id:
          }
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:aggregate) { JobOrders::Aggregates::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when there is an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            )
          ]
        end

        it "emits a job order creation failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::CreationFailed::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                job_id: message.data.job_id,
                reason: "There is an existing active job order present"
              }
            )
            .and_call_original

          subject
        end
      end

      context "when there is not an active job order" do
        let(:messages) { [] }

        it "emits a job order added event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::Added::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                job_id: message.data.job_id
              }
            )
            .and_call_original

          subject
        end
      end
    end

    context "when the message is activate job order" do
      before do
        messages.each do |message|
          Event.from_message!(message)
        end
      end

      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::Activate::V1,
          aggregate:,
          data: Core::Nothing
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:aggregate) { JobOrders::Aggregates::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when there is an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            )
          ]
        end

        it "emits a job order activation failed event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::ActivationFailed::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                reason: "There is an existing active job order present"
              }
            )
            .and_call_original

          subject
        end
      end

      context "when there is not a job order" do
        let(:messages) do
          []
        end

        it "reports to sentry a job order was not found" do
          expect(Sentry)
            .to receive(:capture_exception)
            .with(
              MessageConsumer::FailedToHandleMessage.new("Job Order not found", message)
            )
            .and_call_original

          subject
        end
      end

      context "when there is not an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            ),
            build(
              :message,
              schema: JobOrders::Events::NotFilled::V1,
              aggregate:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: Core::Nothing
            )
          ]
        end

        it "emits a job order activated event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::Activated::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: Core::Nothing
            )
            .and_call_original

          subject
        end
      end
    end

    context "for events that might trigger new job order status" do
      shared_examples "emits new status events if necessary" do
        context "when possible to emit a new status" do
          before do
            expect_any_instance_of(JobOrders::Projectors::JobOrderExistingStatus)
              .to receive(:project)
              .with(filtered_messages)
              .and_return(existing_status)
            expect_any_instance_of(JobOrders::Projectors::JobOrderStatus)
              .to receive(:project)
              .with(filtered_messages)
              .and_return(new_status)

            expect(MessageService)
              .to receive(:aggregate_events)
              .with(message.aggregate)
              .and_return(messages)
          end

          let(:message1) do
            build(
              :message,
              schema: JobOrders::Events::CandidateAdded::V2,
              data: {
                person_id: SecureRandom.uuid
              },
              occurred_at: message.occurred_at - 1.day
            )
          end
          let(:message2) do
            build(
              :message,
              schema: JobOrders::Events::CandidateAdded::V2,
              data: {
                person_id: SecureRandom.uuid
              },
              occurred_at: message.occurred_at + 1.day
            )
          end

          let(:messages) { [message1, message2] }
          let(:filtered_messages) { [message1] }

          context "when the current status and new status are the same" do
            let(:existing_status) do
              JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
            end
            let(:new_status) do
              JobOrders::Projectors::JobOrderStatus::Projection.new(
                order_count: 1,
                candidates: {},
                not_filled?: false
              )
            end

            it "does not emit a new message" do
              expect(message_service)
                .not_to receive(:create_once_for_trace!)

              subject
            end
          end

          context "when the current status and new status are the different" do
            context "when the new status should be activated" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::StalledStatus::WAITING_ON_EMPLOYER)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 2,
                  candidates: {},
                  not_filled?: false
                )
              end

              it "emits an activated event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: JobOrders::Events::Activated::V1,
                    data: Core::Nothing
                  )

                subject
              end
            end

            context "when the new status should be stalled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 2,
                  candidates: { one: :recommended, two: :recommended },
                  not_filled?: false
                )
              end

              it "emits an waiting on employer event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: JobOrders::Events::Stalled::V1,
                    data: {
                      status: JobOrders::StalledStatus::WAITING_ON_EMPLOYER
                    }
                  )

                subject
              end
            end

            context "when the new status should be filled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 1,
                  candidates: { one: :hired },
                  not_filled?: false
                )
              end

              it "emits an filled event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: JobOrders::Events::Filled::V1,
                    data: Core::Nothing
                  )

                subject
              end
            end

            context "when the new status should be not filled" do
              let(:existing_status) do
                JobOrders::Projectors::JobOrderExistingStatus::Projection.new(status: JobOrders::ActivatedStatus::OPEN)
              end
              let(:new_status) do
                JobOrders::Projectors::JobOrderStatus::Projection.new(
                  order_count: 1,
                  candidates: { one: :hired },
                  not_filled?: true
                )
              end

              it "emits a not filled event" do
                expect(message_service)
                  .to receive(:create_once_for_trace!)
                  .with(
                    trace_id: message.trace_id,
                    aggregate: message.aggregate,
                    schema: JobOrders::Events::NotFilled::V1,
                    data: Core::Nothing
                  )

                subject
              end
            end
          end
        end
      end

      context "when the message is job order candidate added" do
        let(:message) do
          build(
            :message,
            schema: JobOrders::Events::CandidateAdded::V2,
            data: {
              person_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order candidate recommended" do
        let(:message) do
          build(
            :message,
            schema: JobOrders::Events::CandidateRecommended::V2,
            data: {
              person_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order candidate hired" do
        let(:message) do
          build(
            :message,
            schema: JobOrders::Events::CandidateHired::V2,
            data: {
              person_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order candidate rescinded" do
        let(:message) do
          build(
            :message,
            schema: JobOrders::Events::CandidateRescinded::V2,
            data: {
              person_id: SecureRandom.uuid
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end

      context "when the message is job order added" do
        let(:message) do
          build(
            :message,
            schema: JobOrders::Events::OrderCountAdded::V1,
            data: {
              order_count: 2
            }
          )
        end

        it_behaves_like "emits new status events if necessary"
      end
    end
  end
end
