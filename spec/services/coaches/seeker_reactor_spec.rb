require 'rails_helper'

RSpec.describe Coaches::SeekerReactor do
  let(:user_id) { "9f769972-c41c-4b58-a056-bffb714ea24d" }
  let(:seeker_id) { "75372772-49dc-4884-b4ae-1d408e030aa4" }
  let(:note_id1) { "78f22f6c-a770-46fc-a83c-1ad6cda4b8f9" }
  let(:updated_note) { "This note was updated" }
  let(:consumer) { described_class.new(event_service: EventService.new) }

  it_behaves_like "a message consumer"

  describe ".add_lead" do
    subject { consumer.add_lead(coach:, first_name:, last_name:, lead_id:, phone_number:, now:) }

    let(:coach) { create(:coaches__coach) }
    let(:first_name) { "John" }
    let(:last_name) { "Chabot" }
    let(:phone_number) { "333-333-3333" }
    let(:lead_id) { "ffc354f5-e1c3-4859-b9f0-1e94106ddc96" }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::LeadAdded::V1,
        coach_id: coach.id,
        data: Events::LeadAdded::Data::V1.new(
          first_name:,
          last_name:,
          phone_number:,
          lead_id:,
          email: nil,
          lead_captured_by: coach.email
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".add_note" do
    subject { consumer.add_note(context_id:, coach:, note: "This is a new note", note_id: note_id1, now:) }

    let(:coach) { create(:coaches__coach) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:context_id) { user_id }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::NoteAdded::V3,
        context_id:,
        data: Events::NoteAdded::Data::V2.new(
          originator: coach.email,
          note: "This is a new note",
          note_id: note_id1
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".delete_note" do
    subject { consumer.delete_note(coach:, context_id:, note_id: note.note_id, now:) }

    let(:note) { create(:coaches__seeker_note, note_id: note_id1) }
    let(:coach) { create(:coaches__coach) }
    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:context_id) { user_id }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::NoteDeleted::V3,
        context_id:,
        data: Events::NoteDeleted::Data::V2.new(
          originator: coach.email,
          note_id: note_id1
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".modify_note" do
    subject { consumer.modify_note(context_id:, coach:, note_id: note_id1, note: updated_note, now:) }

    let(:coach) { create(:coaches__coach) }
    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:context_id) { user_id }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::NoteModified::V3,
        context_id:,
        data: Events::NoteModified::Data::V2.new(
          originator: coach.email,
          note_id: note_id1,
          note: updated_note
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".recommend_job" do
    subject { consumer.recommend_job(context_id:, job_id:, coach:, now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:coach) { create(:coaches__coach) }
    let(:job_id) { create(:coaches__job).job_id }
    let(:context_id) { user_id }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::JobRecommended::V2,
        context_id:,
        data: Events::JobRecommended::Data::V1.new(
          job_id:,
          coach_id: coach.coach_id
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".certify" do
    subject { consumer.certify(context_id:, coach:, now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:coach) { create(:coaches__coach, user_id: user.id) }
    let(:user) { create(:user) }
    let(:context_id) { SecureRandom.uuid }
    let(:seeker_id) { SecureRandom.uuid }
    let!(:csc) { create(:coaches__coach_seeker_context, context_id:, seeker_id:) }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::SeekerCertified::V1,
        seeker_id:,
        data: Events::SeekerCertified::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          coach_first_name: user.first_name,
          coach_last_name: user.last_name
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".update_barriers" do
    subject { consumer.update_barriers(context_id:, barriers: [barrier.barrier_id], now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:barrier) { create(:barrier) }
    let(:context_id) { user_id }

    it "creates an event" do
      expect(Events::BarrierUpdated::Data::V1)
        .to receive(:new)
        .with(
          barriers: [barrier.barrier_id]
        )
        .and_call_original

      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::BarrierUpdated::V2,
        context_id:,
        data: be_a(Events::BarrierUpdated::Data::V1),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".assign_coach" do
    subject { consumer.assign_coach(context_id:, coach_id:, coach_email: "coach@blocktrainapp.com", now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:coach_id) { SecureRandom.uuid }
    let(:context_id) { user_id }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::CoachAssigned::V2,
        context_id:,
        data: Events::CoachAssigned::Data::V1.new(
          coach_id:,
          email: "coach@blocktrainapp.com"
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".update_skill_level" do
    subject { consumer.update_skill_level(context_id:, skill_level: "advanced", now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:context_id) { user_id }

    it "creates an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::SkillLevelUpdated::V2,
        context_id:,
        data: Events::SkillLevelUpdated::Data::V1.new(
          skill_level: "advanced"
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end
end
