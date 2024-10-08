require 'rails_helper'

RSpec.describe JobOrders::JobOrdersReactor do
  it_behaves_like "a replayable message consumer"

  let(:instance) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:trace_id) { SecureRandom.uuid }
  let(:job_order_id) { SecureRandom.uuid }
  let(:job_id) { SecureRandom.uuid }
  let(:person_id) { SecureRandom.uuid }
  let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id:) }

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
      let(:status) { JobOrders::CandidateStatus::ADDED }

      it "emits a added event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: JobOrders::Events::CandidateAdded::V3,
            job_order_id:,
            trace_id:,
            data: {
              person_id:
            },
            metadata: {
              requestor_type: nil,
              requestor_id: nil,
              requestor_email: nil
            }
          ).and_call_original

        subject
      end
    end

    context "recommended" do
      let(:status) { JobOrders::CandidateStatus::RECOMMENDED }

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

    context "screened" do
      let(:status) { JobOrders::CandidateStatus::SCREENED }

      it "emits a screened event" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: JobOrders::Events::CandidateScreened::V1,
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
      let(:status) { JobOrders::CandidateStatus::HIRED }

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
      let(:status) { JobOrders::CandidateStatus::RESCINDED }

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

  describe "#handle_message" do
    subject { instance.handle_message(message) }

    before do
      messages.each do |message|
        Event.from_message!(message)
      end
    end

    let(:messages) { [] }

    context "when the message is add candidate" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::AddCandidate::V2,
          stream:,
          data: {
            person_id:
          },
          metadata: {
            requestor_type: nil,
            requestor_id: nil,
            requestor_email: nil
          }
        )
      end
      let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when the candidate has previously been added" do
        let(:messages) do
          [
            build(
              :message,
              schema: JobOrders::Events::CandidateAdded::V3,
              stream:,
              data: {
                person_id:
              },
              metadata: {
                requestor_type: nil,
                requestor_id: nil,
                requestor_email: nil
              }
            )
          ]
        end
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end

      context "when the candidate has not previously been added" do
        let(:messages) { [] }

        it "emits a candidate added event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::CandidateAdded::V3,
              stream: message.stream,
              trace_id: message.trace_id,
              data: {
                person_id: message.data.person_id
              },
              metadata: {
                requestor_type: nil,
                requestor_id: nil,
                requestor_email: nil
              }
            )
            .and_call_original

          subject
        end
      end
    end

    context "when the message is add order count" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::AddOrderCount::V1,
          stream:,
          data: {
            order_count: 10
          }
        )
      end
      let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id:) }

      it "emits a order count added event" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: JobOrders::Events::OrderCountAdded::V1,
            stream: message.stream,
            trace_id: message.trace_id,
            data: {
              order_count: message.data.order_count
            }
          )
          .and_call_original

        subject
      end
    end

    context "when the message is closed as not filled" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::CloseAsNotFilled::V1,
          stream:,
          data: Core::Nothing
        )
      end
      let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id:) }

      it "emits a closed not filled event" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: JobOrders::Events::ClosedNotFilled::V1,
            stream: message.stream,
            trace_id: message.trace_id,
            data: Core::Nothing
          )
          .and_call_original

        subject
      end
    end

    context "when the message is add screener questions" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::AddScreenerQuestions::V1,
          stream:,
          data: {
            screener_questions_id:
          }
        )
      end

      let(:screener_questions_id) { SecureRandom.uuid }

      context "when the screener questions exists" do
        let(:messages) do
          [
            build(
              :message,
              schema: Screeners::Events::QuestionsCreated::V1,
              stream_id: screener_questions_id
            )
          ]
        end

        it "emits a screener questions added event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::ScreenerQuestionsAdded::V1,
              stream: message.stream,
              trace_id: message.trace_id,
              data: {
                screener_questions_id: message.data.screener_questions_id
              }
            )
            .and_call_original

          subject
        end
      end

      context "when the screener questions do not exist exists" do
        it "does nothing" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service).not_to receive(:save!)

          subject
        end
      end
    end

    context "when the message is bypass screener questions" do
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::BypassScreenerQuestions::V1,
          stream:
        )
      end

      let(:screener_questions_id) { SecureRandom.uuid }

      it "emits a screener questions bypassed event" do
        expect(message_service)
          .to receive(:create_once_for_stream!)
          .with(
            schema: JobOrders::Events::ScreenerQuestionsBypassed::V1,
            stream: message.stream,
            trace_id: message.trace_id,
            data: Core::Nothing
          )
          .and_call_original

        subject
      end
    end

    context "when the message is job created" do
      let(:message) do
        build(
          :message,
          schema: Jobs::Events::JobCreated::V3,
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
              job_id: message.stream.id
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
              stream: job_order1.stream,
              schema: JobOrders::Events::StatusUpdated::V1,
              occurred_at: Time.zone.local(2019, 6, 1),
              data: {
                status: JobOrders::OrderStatus::NOT_FILLED
              }
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
                schema: JobOrders::Events::CandidateAdded::V3,
                trace_id: message.trace_id,
                stream: job_order2.stream,
                data: {
                  person_id:
                },
                metadata: {
                  requestor_type: nil,
                  requestor_id: nil,
                  requestor_email: nil
                }
              )
              .and_call_original

            expect(message_service)
              .to receive(:create_once_for_trace!)
              .with(
                schema: JobOrders::Events::CandidateApplied::V2,
                trace_id: message.trace_id,
                stream: job_order2.stream,
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
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::Add::V1,
          stream:,
          data: {
            job_id:
          }
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when there is an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              stream:,
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
              stream: message.stream,
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
              stream: message.stream,
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
      let(:message) do
        build(
          :message,
          schema: JobOrders::Commands::Activate::V1,
          stream:,
          data: Core::Nothing
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id: SecureRandom.uuid) }

      context "when there is an active job order" do
        let(:messages) do
          [
            build(
              :message,
              schema: JobOrders::Events::Added::V1,
              stream:,
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
              stream: message.stream,
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
              stream:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: {
                job_id:
              }
            ),
            build(
              :message,
              schema: JobOrders::Events::StatusUpdated::V1,
              stream:,
              occurred_at: Time.zone.local(2019, 1, 1),
              data: { status: JobOrders::OrderStatus::NOT_FILLED }
            )
          ]
        end

        it "emits a job order activated event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: JobOrders::Events::Reactivated::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: Core::Nothing
            )
            .and_call_original

          subject
        end
      end
    end
  end
end
