require 'rails_helper'

RSpec.describe Coaches::CoachesReactor do # rubocop:disable Metrics/BlockLength
  let(:user_id) { "9f769972-c41c-4b58-a056-bffb714ea24d" }
  let(:seeker_id) { "75372772-49dc-4884-b4ae-1d408e030aa4" }
  let(:note_id) { "78f22f6c-a770-46fc-a83c-1ad6cda4b8f9" }
  let(:trace_id) { "42000038-7e82-48ca-ac18-72ebc08bdbeb" }
  let(:person_id) { SecureRandom.uuid }
  let(:updated_note) { "This note was updated" }
  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:messages) { [] }

  before do
    messages.each do |m|
      Event.from_message!(m)
    end
  end

  it_behaves_like "a non replayable message consumer"

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    context "when the message is a assign_coach command" do
      let(:message) do
        build(
          :message,
          aggregate_id: person_id,
          schema: Commands::AssignCoach::V2,
          data: {
            coach_id: SecureRandom.uuid
          }
        )
      end

      let(:person_added) do
        build(
          :message,
          aggregate_id: person_id,
          schema: Events::PersonAdded::V1,
          data: {
            first_name: "Jim",
            last_name: "Jim",
            email: "A@B.com",
            phone_number: "333-333-3333",
            date_of_birth: nil
          }
        )
      end

      context "When person added as not occurred" do
        let(:message_service) { double }
        let(:messages) { [] }

        it "does nothing" do
          expect(message_service)

          subject
        end
      end

      context "When person added has occured but it was already assigned" do
        let(:messages) { [person_added] }

        it "emits a coach assigned event" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Events::CoachAssigned::V3,
              aggregate: message.aggregate,
              data: {
                coach_id: message.data.coach_id
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end

    context "when the message is a job_recommended event" do
      let(:message) do
        build(
          :message,
          schema: Events::JobRecommended::V3,
          aggregate_id: person_id,
          data: {
            job_id:,
            coach_id:
          }
        )
      end

      let(:job_id) { SecureRandom.uuid }
      let(:coach_id) { SecureRandom.uuid }
      let(:person_id) { SecureRandom.uuid }

      context "when there is a user associated with this person" do
        let(:messages) do
          [
            build(
              :message,
              schema: Events::PersonAssociatedToUser::V1,
              aggregate_id: person_id,
              data: {
                user_id:
              }
            )
          ]
        end
        let(:user_id) { SecureRandom.uuid }

        it "emits a send message command" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Commands::SendMessage::V1,
              message_id: be_a(String),
              trace_id: message.trace_id,
              data: {
                user_id:,
                title: "From your SkillArc career coach",
                body: "Check out this job",
                url: "#{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
              },
              metadata: {
                requestor_type: Requestor::Kinds::COACH,
                requestor_id: message.data.coach_id
              }
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when there isn't a user associated with this person" do
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end
    end

    context "when the message is coach reminder completed" do
      let(:message) do
        build(
          :message,
          schema: Events::CoachReminderCompleted::V1,
          aggregate_id: coach_id,
          data: {
            reminder_id:
          }
        )
      end

      let(:coach_id) { SecureRandom.uuid }
      let(:reminder_id) { SecureRandom.uuid }

      context "when the reminder scheduled is found" do
        let(:messages) do
          [
            build(
              :message,
              schema: Events::CoachReminderScheduled::V2,
              aggregate_id: coach_id,
              data: {
                reminder_id:,
                person_id: nil,
                note: "dude",
                message_task_id:,
                reminder_at: Time.zone.now
              }
            )
          ]
        end
        let(:message_task_id) { SecureRandom.uuid }

        it "fires off a cancel task command" do
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Commands::CancelTask::V1,
              trace_id: message.trace_id,
              task_id: message_task_id,
              data: Messages::Nothing,
              metadata: {
                requestor_type: Requestor::Kinds::COACH,
                requestor_id: coach_id
              }
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when the reminder scheduled is not found" do
        let(:messages) { [] }
        let(:message_service) { double }

        it "does nothing" do
          subject
        end
      end
    end
  end

  describe "#add_attribute" do
    subject { consumer.add_attribute(person_id:, seeker_attribute_id:, attribute_id:, attribute_name:, attribute_values:, trace_id:) }

    let(:seeker_attribute_id) { SecureRandom.uuid }
    let(:attribute_id) { SecureRandom.uuid }
    let(:attribute_name) { "Cool factor" }
    let(:attribute_values) { ["Cool"] }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::PersonAttributeAdded::V1,
        person_id:,
        trace_id:,
        data: {
          id: seeker_attribute_id,
          attribute_id:,
          attribute_name:,
          attribute_values:
        }
      ).and_call_original

      subject
    end
  end

  describe "#recommend_for_job_order" do
    subject { consumer.recommend_for_job_order(seeker_id:, job_order_id:, trace_id:) }

    let(:job_order_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobOrderCandidateAdded::V1,
        job_order_id:,
        trace_id:,
        data: {
          seeker_id:
        }
      ).and_call_original

      subject
    end
  end

  describe "#remove_attribute" do
    subject { consumer.remove_attribute(person_id:, seeker_attribute_id:, trace_id:) }

    let(:seeker_attribute_id) { SecureRandom.uuid }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::PersonAttributeRemoved::V1,
        person_id:,
        trace_id:,
        data: {
          id: seeker_attribute_id
        }
      ).and_call_original

      subject
    end
  end

  describe "#add_note" do
    subject { consumer.add_note(person_id:, originator:, note: "This is a new note", note_id:, trace_id:) }

    let(:originator) { "someone" }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::NoteAdded::V4,
        person_id:,
        trace_id:,
        data: {
          originator:,
          note: "This is a new note",
          note_id:
        }
      ).and_call_original

      subject
    end
  end

  describe "#delete_note" do
    subject { consumer.delete_note(originator:, person_id:, note_id:, trace_id:) }

    let(:originator) { "someone" }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::NoteDeleted::V4,
        person_id:,
        trace_id:,
        data: {
          originator:,
          note_id:
        }
      ).and_call_original

      subject
    end
  end

  describe "#modify_note" do
    subject { consumer.modify_note(person_id:, originator:, note_id:, note: updated_note, trace_id:) }

    let(:originator) { "someone" }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::NoteModified::V4,
        person_id:,
        trace_id:,
        data: {
          originator:,
          note_id:,
          note: updated_note
        }
      ).and_call_original

      subject
    end
  end

  describe "#create_reminder" do
    subject { consumer.create_reminder(coach:, note:, reminder_at:, trace_id:, person_id:) }

    let(:coach) { create(:coaches__coach) }
    let(:note) { "Do this thing" }
    let(:reminder_at) { Time.zone.local(2020, 1, 1) }
    let(:trace_id) { SecureRandom.uuid }
    let(:person_id) { nil }

    it "creates an coach reminder event and schedules a future reminder message" do
      expect(message_service)
        .to receive(:create!).with(
          schema: Events::CoachReminderScheduled::V2,
          coach_id: coach.coach_id,
          trace_id:,
          data: {
            reminder_id: be_a(String),
            person_id:,
            note:,
            message_task_id: be_a(String),
            reminder_at:
          }
        ).and_call_original

      expect(message_service)
        .to receive(:create!).with(
          schema: Commands::ScheduleTask::V1,
          task_id: be_a(String),
          trace_id:,
          data: {
            execute_at: reminder_at - 1.hour,
            command: be_a(Message)
          },
          metadata: {
            requestor_type: Requestor::Kinds::USER,
            requestor_id: coach.user_id
          }
        ).and_call_original

      subject
    end

    context "when context_id is nil" do
      it "The message does not includes a link to the context page" do
        allow(message_service)
          .to receive(:build)
          .and_call_original

        expect(message_service)
          .to receive(:build).with(
            schema: Commands::SendMessage::V1,
            trace_id:,
            message_id: be_a(String),
            data: {
              user_id: coach.user_id,
              title: "Reminder",
              body: "At January 01, 2020 00:00: Do this thing",
              url: nil
            },
            metadata: {
              requestor_type: Requestor::Kinds::USER,
              requestor_id: coach.user_id
            }
          ).and_call_original

        subject
      end
    end

    context "when context_id is present" do
      let(:person_id) { SecureRandom.uuid }

      it "The message includes a link to the context page" do
        allow(message_service)
          .to receive(:build)
          .and_call_original

        expect(message_service)
          .to receive(:build).with(
            schema: Commands::SendMessage::V1,
            trace_id:,
            message_id: be_a(String),
            data: {
              user_id: coach.user_id,
              title: "Reminder",
              body: "At January 01, 2020 00:00: Do this thing",
              url: "#{ENV.fetch('FRONTEND_URL', nil)}/coaches/contexts/#{person_id}"
            },
            metadata: {
              requestor_type: Requestor::Kinds::USER,
              requestor_id: coach.user_id
            }
          ).and_call_original

        subject
      end
    end
  end

  describe "#complete_reminder" do
    subject { consumer.complete_reminder(coach:, reminder_id:, trace_id:) }

    let(:coach) { create(:coaches__coach) }
    let(:reminder_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }

    it "fires off a coach reminder completed" do
      expect(message_service)
        .to receive(:create!).with(
          schema: Events::CoachReminderCompleted::V1,
          coach_id: coach.coach_id,
          trace_id:,
          data: {
            reminder_id:
          }
        ).and_call_original

      subject
    end
  end

  describe "#recommend_job" do
    subject { consumer.recommend_job(person_id:, job_id:, coach:, trace_id:) }

    let(:coach) { create(:coaches__coach) }
    let(:job_id) { create(:coaches__job).job_id }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::JobRecommended::V3,
        person_id:,
        trace_id:,
        data: {
          job_id:,
          coach_id: coach.coach_id
        }
      ).and_call_original

      subject
    end
  end

  describe "#certify" do
    subject { consumer.certify(person_id:, coach:, trace_id:) }

    let(:coach) { create(:coaches__coach, user_id: user.id) }
    let(:user) { create(:user) }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::PersonCertified::V1,
        person_id:,
        trace_id:,
        data: {
          coach_id: coach.coach_id,
          coach_email: coach.email,
          coach_first_name: user.first_name,
          coach_last_name: user.last_name
        }
      ).and_call_original

      subject
    end
  end

  describe "#update_barriers" do
    subject { consumer.update_barriers(person_id:, barriers: [barrier.barrier_id], trace_id:) }

    let(:barrier) { create(:barrier) }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::BarrierUpdated::V3,
        person_id:,
        trace_id:,
        data: {
          barriers: [barrier.barrier_id]
        }
      ).and_call_original

      subject
    end
  end

  describe "#assign_coach" do
    subject { consumer.assign_coach(person_id:, coach_id:, trace_id:) }

    let(:coach_id) { SecureRandom.uuid }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::CoachAssigned::V3,
        person_id:,
        trace_id:,
        data: {
          coach_id:
        }
      ).and_call_original

      subject
    end
  end

  describe "#update_skill_level" do
    subject { consumer.update_skill_level(person_id:, skill_level: "advanced", trace_id:) }

    it "creates an event" do
      expect(message_service).to receive(:create!).with(
        schema: Events::SkillLevelUpdated::V3,
        person_id:,
        trace_id:,
        data: {
          skill_level: "advanced"
        }
      ).and_call_original

      subject
    end
  end
end
