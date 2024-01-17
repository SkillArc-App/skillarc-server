require 'rails_helper'

RSpec.describe Coaches::SeekerService do
  let(:non_seeker_user_created) { build(:event, :user_created, aggregate_id: "123", data: { email: "f@f.f" }) }
  let(:user_without_email) { build(:event, :user_created, aggregate_id: user_without_email_id, data: { first_name: "Hannah", last_name: "Block" }) }
  let(:profile_without_email) { build(:event, :profile_created, aggregate_id: user_without_email_id, data: { id: profile_without_email_id }) }
  let(:user_created) { build(:event, :user_created, aggregate_id: user_id, data: { email: "hannah@blocktrainapp.com" }) }
  let(:user_updated) { build(:event, :user_updated, aggregate_id: user_id, data: { first_name: "Hannah", last_name: "Block", phone_number: "1234567890" }) }
  let(:other_user_created) { build(:event, :user_created, aggregate_id: other_user_id, data: { email: "katina@gmail.com", first_name: "Katina", last_name: "Hall" }) }
  let(:profile_created) { build(:event, :profile_created, aggregate_id: user_id, data: { id: profile_id }) }
  let(:other_profile_created) { build(:event, :profile_created, aggregate_id: other_user_id, data: { id: other_profile_id }) }
  let(:note_with_id_added1) { build(:event, :note_added, aggregate_id: profile_id, data: { note: "This is a note with an id 1", note_id: note_id1, coach_email: "coach@blocktrainapp.com" }, occurred_at: time1) }
  let(:note_with_id_added2) { build(:event, :note_added, aggregate_id: profile_id, data: { note: "This is a note with an id 2", note_id: note_id2, coach_email: "coach@blocktrainapp.com" }, occurred_at: time1) }
  let(:applicant_status_updated1) { build(:event, :applicant_status_updated, aggregate_id: job_id, data: status_updated1, occurred_at: time2) }
  let(:applicant_status_updated2) { build(:event, :applicant_status_updated, aggregate_id: job_id, data: status_updated2, occurred_at: time2) }
  let(:applicant_status_updated3) { build(:event, :applicant_status_updated, aggregate_id: job_id, data: status_updated3, occurred_at: time2) }
  let(:applicant_status_updated4) { build(:event, :applicant_status_updated, aggregate_id: job_id, data: status_updated4, occurred_at: time2) }
  let(:note_deleted) { build(:event, :note_deleted, aggregate_id: profile_id, data: { note: "This is a note with an id", note_id: note_id1 }, occurred_at: time1) }
  let(:note_modified) { build(:event, :note_modified, aggregate_id: profile_id, data: { note: updated_note, note_id: note_id2 }, occurred_at: time1) }
  let(:skill_level_updated) { build(:event, :skill_level_updated, aggregate_id: profile_id, data: { skill_level: "advanced" }, occurred_at: time1) }
  let(:coach_assigned) { build(:event, :coach_assigned, aggregate_id: profile_id, data: { coach_id: "123", email: "coach@blocktrainapp.com" }, occurred_at: time1) }
  let(:status_updated1) do
    {
      job_id:,
      employer_name: employer_name1,
      profile_id: other_profile_id,
      user_id: other_user_id,
      applicant_id: applicant_id1,
      employment_title: employment_title1,
      status: status1
    }
  end
  let(:status_updated2) do
    {
      job_id:,
      employer_name: employer_name1,
      profile_id: other_profile_id,
      user_id: other_user_id,
      applicant_id: applicant_id1,
      employment_title: employment_title1,
      status: status2
    }
  end
  let(:status_updated3) do
    {
      job_id:,
      profile_id:,
      user_id:,
      employer_name: employer_name2,

      applicant_id: applicant_id2,
      employment_title: employment_title2,
      status: status1
    }
  end
  let(:status_updated4) do
    {
      job_id:,
      employer_name: employer_name2,
      profile_id: other_profile_id,
      user_id: other_user_id,
      applicant_id: applicant_id3,
      employment_title: employment_title2,
      status: status1
    }
  end

  let(:time1) { Time.utc(2020, 1, 1) }
  let(:time2) { Time.utc(2022, 1, 1) }
  let(:employment_title1) { "A place of employment" }
  let(:employment_title2) { "Another place of employment" }
  let(:status1) { "Phone screening" }
  let(:status2) { "Hired" }
  let(:user_without_email_id) { "4f878ed9-5cb9-429b-ab22-969b46305ea2" }
  let(:profile_without_email_id) { "b09195f7-a15e-461f-bec2-1e4744122fdf" }
  let(:user_id) { "9f769972-c41c-4b58-a056-bffb714ea24d" }
  let(:other_user_id) { "7a381c1e-6f1c-41e7-b045-6f989acc2cf8" }
  let(:profile_id) { "75372772-49dc-4884-b4ae-1d408e030aa4" }
  let(:other_profile_id) { "2dc66599-1116-4d7a-bdbb-38652fbed6cd" }
  let(:note_id1) { "78f22f6c-a770-46fc-a83c-1ad6cda4b8f9" }
  let(:note_id2) { "a0c1894f-df0d-40d3-bb1d-d68efea4772d" }
  let(:applicant_id1) { "8aac8c6d-5c13-418d-b8e7-fd468fa291de" }
  let(:applicant_id2) { "749d43ba-08b5-40cb-977c-4e8ebd2da04a" }
  let(:applicant_id3) { "71f36a32-9c83-47e7-a22a-3d15b03c2dc0" }
  let(:job_id) { "e43b2338-50bb-467f-85c4-ee26181052e2" }
  let(:updated_note) { "This note was updated" }
  let(:employer_name1) { "Cool company" }
  let(:employer_name2) { "Fun company" }

  before do
    described_class.handle_event(non_seeker_user_created)
    described_class.handle_event(user_without_email)
    described_class.handle_event(profile_without_email)
    described_class.handle_event(user_created)
    described_class.handle_event(user_updated)
    described_class.handle_event(other_user_created)
    described_class.handle_event(profile_created)
    described_class.handle_event(other_profile_created)
    described_class.handle_event(note_with_id_added1)
    described_class.handle_event(note_with_id_added2)
    described_class.handle_event(note_deleted)
    described_class.handle_event(note_modified)
    described_class.handle_event(skill_level_updated)
    described_class.handle_event(coach_assigned)
    described_class.handle_event(applicant_status_updated1)
    described_class.handle_event(applicant_status_updated2)
    described_class.handle_event(applicant_status_updated3)
    described_class.handle_event(applicant_status_updated4)
  end

  describe ".all" do
    subject { described_class.all }

    it "returns all profiles" do
      expected_profile = {
        seekerId: profile_id,
        firstName: "Hannah",
        lastName: "Block",
        email: "hannah@blocktrainapp.com",
        phoneNumber: "1234567890",
        skillLevel: 'advanced',
        lastActiveOn: applicant_status_updated3.occurred_at,
        lastContacted: note_with_id_added1.occurred_at,
        assignedCoach: '123',
        barriers: [],
        notes: [
          {
            note: "This note was updated",
            noteId: note_id2,
            noteTakenBy: "coach@blocktrainapp.com",
            date: Time.utc(2020, 1, 1)
          }
        ],
        applications: [
          {
            jobId: job_id,
            employerName: employer_name2,
            status: status1,
            employmentTitle: employment_title2
          }
        ],
        stage: 'profile_created'
      }
      expected_other_profile = {
        seekerId: other_profile_id,
        firstName: "Katina",
        lastName: "Hall",
        email: "katina@gmail.com",
        phoneNumber: nil,
        skillLevel: 'beginner',
        lastActiveOn: applicant_status_updated4.occurred_at,
        lastContacted: "Never",
        assignedCoach: 'none',
        barriers: [],
        notes: [],
        applications: [
          {
            jobId: job_id,
            employerName: employer_name1,
            status: status2,
            employmentTitle: employment_title1
          },
          {
            jobId: job_id,
            employerName: employer_name2,
            status: status1,
            employmentTitle: employment_title2
          }
        ],
        stage: 'profile_created'
      }

      expect(subject).to contain_exactly(expected_profile, expected_other_profile)
    end
  end

  describe ".find" do
    subject { described_class.find(profile_id) }

    it "returns the profile" do
      expected_profile = {
        seekerId: profile_id,
        firstName: "Hannah",
        lastName: "Block",
        email: "hannah@blocktrainapp.com",
        phoneNumber: "1234567890",
        skillLevel: 'advanced',
        lastActiveOn: applicant_status_updated3.occurred_at,
        lastContacted: note_with_id_added1.occurred_at,
        assignedCoach: '123',
        barriers: [],
        notes: [
          {
            note: "This note was updated",
            noteTakenBy: "coach@blocktrainapp.com",
            date: Time.utc(2020, 1, 1),
            noteId: note_id2
          }
        ],
        applications: [
          {
            status: status1,
            jobId: job_id,
            employmentTitle: employment_title2,
            employerName: employer_name2
          }
        ],
        stage: 'profile_created'
      }

      expect(subject).to eq(expected_profile)
    end

    context "when another events occur which update last active on" do
      [
        Event::EventTypes::EDUCATION_EXPERIENCE_CREATED,
        Event::EventTypes::JOB_SAVED,
        Event::EventTypes::JOB_UNSAVED,
        Event::EventTypes::PERSONAL_EXPERIENCE_CREATED,
        Event::EventTypes::PROFILE_UPDATED,
        Event::EventTypes::ONBOARDING_COMPLETED
      ].each do |event_type|
        context "when a #{event_type} occurs for a seeker" do
          it "updates the last active to when the event occured" do
            described_class.handle_event(build(:event, event_type:, aggregate_id: user_id, occurred_at: time2))

            expect(subject[:lastActiveOn]).to eq(time2)
          end
        end
      end
    end
  end

  describe ".add_note" do
    subject { described_class.add_note(id: profile_id, coach:, note: "This is a new note", note_id: note_id1, now:) }

    let(:coach) { create(:coaches__coach) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(CreateEventJob).to receive(:perform_later).with(
        event_type: Event::EventTypes::NOTE_ADDED,
        aggregate_id: profile_id,
        data: {
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note: "This is a new note",
          note_id: note_id1
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end

  describe ".delete_note" do
    subject { described_class.delete_note(coach:, id: profile_id, note_id: note_id1, now:) }

    let(:coach) { create(:coaches__coach) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(CreateEventJob).to receive(:perform_later).with(
        event_type: Event::EventTypes::NOTE_DELETED,
        aggregate_id: profile_id,
        data: {
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id: note_id1
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end

  describe ".modify_note" do
    subject { described_class.modify_note(id: profile_id, coach:, note_id: note_id2, note: updated_note, now:) }

    let(:coach) { create(:coaches__coach) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(CreateEventJob).to receive(:perform_later).with(
        event_type: Event::EventTypes::NOTE_MODIFIED,
        aggregate_id: profile_id,
        data: {
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id: note_id2,
          note: updated_note
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end

  describe ".assign_coach" do
    subject { described_class.assign_coach(profile_id, "123", "coach@blocktrainapp.com", now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(CreateEventJob).to receive(:perform_later).with(
        event_type: Event::EventTypes::COACH_ASSIGNED,
        aggregate_id: profile_id,
        data: {
          coach_id: "123",
          email: "coach@blocktrainapp.com"
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end

  describe ".update_skill_level" do
    subject { described_class.update_skill_level(profile_id, "advanced", now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(CreateEventJob).to receive(:perform_later).with(
        event_type: Event::EventTypes::SKILL_LEVEL_UPDATED,
        aggregate_id: profile_id,
        data: {
          skill_level: "advanced"
        },
        metadata: {},
        occurred_at: now
      )

      subject
    end
  end
end
