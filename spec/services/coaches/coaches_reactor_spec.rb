require 'rails_helper'

RSpec.describe Coaches::CoachesReactor do
  let(:user_id) { "9f769972-c41c-4b58-a056-bffb714ea24d" }
  let(:seeker_id) { "75372772-49dc-4884-b4ae-1d408e030aa4" }
  let(:note_id) { "78f22f6c-a770-46fc-a83c-1ad6cda4b8f9" }
  let(:trace_id) { "42000038-7e82-48ca-ac18-72ebc08bdbeb" }
  let(:updated_note) { "This note was updated" }
  let(:consumer) { described_class.new(event_service:, command_service:) }
  let(:event_service) { EventService.new }
  let(:command_service) { CommandService.new }

  it_behaves_like "a message consumer"

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is a add_lead command" do
      let(:message) do
        build(
          :message,
          schema: Commands::AddLead::V1,
          data: Commands::AddLead::Data::V1.new(
            email: "an@email.com",
            lead_id: SecureRandom.uuid,
            phone_number: "+1740-333-5555",
            first_name: "Chris",
            last_name: "Brauns",
            lead_captured_by: "a computer"
          )
        )
      end

      it "fires off a lead_added event" do
        expect(event_service)
          .to receive(:create!)
          .with(
            event_schema: Events::LeadAdded::V2,
            context_id: message.data.lead_id,
            trace_id: message.trace_id,
            data: {
              lead_captured_by: message.data.lead_captured_by,
              lead_id: message.data.lead_id,
              phone_number: message.data.phone_number,
              first_name: message.data.first_name,
              last_name: message.data.last_name,
              email: message.data.email
            }
          ).and_call_original

        subject
      end
    end

    context "when the message is a add_note command" do
      let(:message) do
        build(
          :message,
          schema: Commands::AddNote::V1,
          data: Commands::AddNote::Data::V1.new(
            originator: "Cool Person",
            note: "This is a note",
            note_id: SecureRandom.uuid
          )
        )
      end

      it "fires off a noted_added event" do
        expect(event_service)
          .to receive(:create!)
          .with(
            event_schema: Events::NoteAdded::V3,
            context_id: message.aggregate.context_id,
            trace_id: message.trace_id,
            data: {
              originator: message.data.originator,
              note: message.data.note,
              note_id: message.data.note_id
            }
          ).and_call_original

        subject
      end
    end

    context "when the message is a assign_coach command" do
      let(:message) do
        build(
          :message,
          schema: Commands::AssignCoach::V1,
          data: Commands::AssignCoach::Data::V1.new(
            coach_email: "katina@skillarc.com"
          )
        )
      end

      context "when there is a coach for that email" do
        let!(:coach) { create(:coaches__coach, email: "katina@skillarc.com") }

        it "fires off a lead_added event" do
          expect(event_service)
            .to receive(:create!)
            .with(
              event_schema: Events::CoachAssigned::V2,
              context_id: message.aggregate.context_id,
              trace_id: message.trace_id,
              data: {
                coach_id: coach.coach_id,
                email: coach.email
              }
            ).and_call_original

          subject
        end
      end

      context "when there isn't a coach for that email" do
        it "does not fire off an event" do
          expect(event_service)
            .not_to receive(:create!)

          subject
        end
      end
    end

    context "when the message is a lead_added event" do
      let(:message) do
        build(
          :message,
          schema: Events::LeadAdded::V2,
          data: {
            email: "john@skillarc.com",
            lead_id: SecureRandom.uuid,
            phone_number: "333-333-3333",
            first_name: "John",
            last_name: "Chabot",
            lead_captured_by: "cal.com"
          }
        )
      end

      context "when there is a coach for that email" do
        it "fires off a assign_coach command" do
          expect(command_service)
            .to receive(:create!)
            .with(
              command_schema: Commands::AssignCoach::V1,
              context_id: message.aggregate.context_id,
              trace_id: message.trace_id,
              data: {
                coach_email: message.data.lead_captured_by
              }
            ).and_call_original

          subject
        end
      end
    end
  end

  describe "#add_lead" do
    subject { consumer.add_lead(lead_captured_by:, first_name:, last_name:, lead_id:, phone_number:, trace_id:) }

    let(:lead_captured_by) { "someone@cool.com" }
    let(:first_name) { "John" }
    let(:last_name) { "Chabot" }
    let(:phone_number) { "333-333-3333" }
    let(:lead_id) { "ffc354f5-e1c3-4859-b9f0-1e94106ddc96" }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::LeadAdded::V2,
        context_id: lead_id,
        trace_id:,
        data: {
          first_name:,
          last_name:,
          phone_number:,
          lead_id:,
          email: nil,
          lead_captured_by:
        }
      ).and_call_original

      subject
    end
  end

  describe "#add_note" do
    subject { consumer.add_note(context_id:, originator:, note: "This is a new note", note_id:, trace_id:) }

    let(:originator) { "someone" }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::NoteAdded::V3,
        context_id:,
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
    subject { consumer.delete_note(originator:, context_id:, note_id:, trace_id:) }

    let(:originator) { "someone" }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::NoteDeleted::V3,
        context_id:,
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
    subject { consumer.modify_note(context_id:, originator:, note_id:, note: updated_note, trace_id:) }

    let(:originator) { "someone" }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::NoteModified::V3,
        context_id:,
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

  describe "#recommend_job" do
    subject { consumer.recommend_job(context_id:, job_id:, coach:, trace_id:) }

    let(:coach) { create(:coaches__coach) }
    let(:job_id) { create(:coaches__job).job_id }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::JobRecommended::V2,
        context_id:,
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
    subject { consumer.certify(seeker_id:, coach:, trace_id:) }

    let(:coach) { create(:coaches__coach, user_id: user.id) }
    let(:user) { create(:user) }
    let(:seeker_id) { SecureRandom.uuid }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::SeekerCertified::V1,
        seeker_id:,
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
    subject { consumer.update_barriers(context_id:, barriers: [barrier.barrier_id], trace_id:) }

    let(:barrier) { create(:barrier) }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::BarrierUpdated::V2,
        context_id:,
        trace_id:,
        data: {
          barriers: [barrier.barrier_id]
        }
      ).and_call_original

      subject
    end
  end

  describe "#assign_coach" do
    subject { consumer.assign_coach(context_id:, coach_id:, coach_email: "coach@blocktrainapp.com", trace_id:) }

    let(:coach_id) { SecureRandom.uuid }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::CoachAssigned::V2,
        context_id:,
        trace_id:,
        data: {
          coach_id:,
          email: "coach@blocktrainapp.com"
        }
      ).and_call_original

      subject
    end
  end

  describe "#update_skill_level" do
    subject { consumer.update_skill_level(context_id:, skill_level: "advanced", trace_id:) }

    let(:context_id) { user_id }

    it "creates an event" do
      expect(event_service).to receive(:create!).with(
        event_schema: Events::SkillLevelUpdated::V2,
        context_id:,
        trace_id:,
        data: {
          skill_level: "advanced"
        }
      ).and_call_original

      subject
    end
  end
end
