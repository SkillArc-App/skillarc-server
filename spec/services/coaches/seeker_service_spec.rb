require 'rails_helper'

RSpec.describe Coaches::SeekerService do # rubocop:disable Metrics/BlockLength
  let(:lead_added) { build(:events__message, :lead_added, aggregate_id: lead_id, data: lead, occurred_at: time1) }
  let(:non_seeker_user_created) { build(:events__message, :user_created, aggregate_id: coach_user_id, data: Events::Common::UntypedHashWrapper.build(email: "f@f.f")) }
  let(:user_without_email) { build(:events__message, :user_created, aggregate_id: user_without_email_id, data: Events::Common::UntypedHashWrapper.build(first_name: "Hannah", last_name: "Block")) }
  let(:seeker_without_email) { build(:events__message, :profile_created, aggregate_id: user_without_email_id, data: Events::SeekerCreated::Data::V1.new(id: seeker_without_email_id, user_id: user_without_email_id)) }
  let(:user_created) { build(:events__message, :user_created, aggregate_id: user_id, data: Events::Common::UntypedHashWrapper.new(email: "hannah@blocktrainapp.com")) }
  let(:user_updated) { build(:events__message, :user_updated, aggregate_id: user_id, data: Events::Common::UntypedHashWrapper.new(first_name: "Hannah", last_name: "Block", phone_number: "1234567890")) }
  let(:other_user_created) { build(:events__message, :user_created, aggregate_id: other_user_id, data: Events::Common::UntypedHashWrapper.new(email: "katina@gmail.com", first_name: "Katina", last_name: "Hall")) }
  let(:seeker_created) { build(:events__message, :profile_created, aggregate_id: user_id, data: Events::SeekerCreated::Data::V1.new(id: seeker_id, user_id:)) }
  let(:other_seeker_created) { build(:events__message, :profile_created, aggregate_id: other_user_id, data: Events::SeekerCreated::Data::V1.new(id: other_seeker_id, user_id: other_user_id)) }
  let(:note_with_id_added1) { build(:events__message, :note_added, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(note: "This is a note with an id 1", note_id: note_id1, coach_email: "coach@blocktrainapp.com"), occurred_at: time1) }
  let(:note_with_id_added2) { build(:events__message, :note_added, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(note: "This is a note with an id 2", note_id: note_id2, coach_email: "coach@blocktrainapp.com"), occurred_at: time1) }
  let(:applicant_status_updated1) { build(:events__message, :applicant_status_updated, version: 2, aggregate_id: job_id, data: status_updated1, occurred_at: time2) }
  let(:applicant_status_updated2) { build(:events__message, :applicant_status_updated, version: 2, aggregate_id: job_id, data: status_updated2, occurred_at: time2) }
  let(:applicant_status_updated3) { build(:events__message, :applicant_status_updated, version: 2, aggregate_id: job_id, data: status_updated3, occurred_at: time2) }
  let(:applicant_status_updated4) { build(:events__message, :applicant_status_updated, version: 2, aggregate_id: job_id, data: status_updated4, occurred_at: time2) }
  let(:note_deleted) { build(:events__message, :note_deleted, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(note: "This is a note with an id", note_id: note_id1), occurred_at: time1) }
  let(:note_modified) { build(:events__message, :note_modified, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(note: updated_note, note_id: note_id2), occurred_at: time1) }
  let(:skill_level_updated) { build(:events__message, :skill_level_updated, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(skill_level: "advanced"), occurred_at: time1) }
  let(:coach_assigned) { build(:events__message, :coach_assigned, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(coach_id: coach_user_id, email: "coach@blocktrainapp.com"), occurred_at: time1) }
  let(:barriers_updated1) { build(:events__message, :barriers_updated, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(barriers: [barrier1.barrier_id]), occurred_at: time1) }
  let(:barriers_updated2) { build(:events__message, :barriers_updated, aggregate_id: seeker_id, data: Events::Common::UntypedHashWrapper.new(barriers: [barrier2.barrier_id]), occurred_at: time1) }
  let(:job_recommended) { build(:events__message, :job_recommended, aggregate_id: seeker_id, data: Events::JobRecommended::Data::V1.new(job_id:, coach_id: coach_user_id), occurred_at: time1) }

  let(:lead) do
    Events::Common::UntypedHashWrapper.new(
      email: nil,
      lead_id: "eaa9b128-4285-4ae9-abb1-9fd548a5b9d5",
      phone_number: "1234567890",
      first_name: "Hannah",
      last_name: "Block",
      lead_captured_by: "khall@blocktrainapp.com"
    )
  end
  let(:status_updated1) do
    Events::ApplicantStatusUpdated::Data::V2.new(
      job_id:,
      applicant_id: applicant_id1,
      applicant_first_name: "Hannah",
      applicant_last_name: "Block",
      applicant_email: "hannah@hannah.com",
      applicant_phone_number: "1234567890",
      employer_name: employer_name1,
      seeker_id: other_seeker_id,
      user_id: other_user_id,
      employment_title: employment_title1,
      status: status1
    )
  end
  let(:status_updated2) do
    Events::ApplicantStatusUpdated::Data::V2.new(
      job_id:,
      applicant_id: applicant_id1,
      applicant_first_name: "Hannah",
      applicant_last_name: "Block",
      applicant_email: "hannah@hannah.com",
      applicant_phone_number: "1234567890",
      employer_name: employer_name1,
      seeker_id: other_seeker_id,
      user_id: other_user_id,
      employment_title: employment_title1,
      status: status2
    )
  end
  let(:status_updated3) do
    Events::ApplicantStatusUpdated::Data::V2.new(
      job_id:,
      applicant_id: applicant_id2,
      applicant_first_name: "Hannah",
      applicant_last_name: "Block",
      applicant_email: "hannah@hannah.com",
      applicant_phone_number: "1234567890",
      seeker_id:,
      user_id:,
      employer_name: employer_name2,
      employment_title: employment_title2,
      status: status1
    )
  end
  let(:status_updated4) do
    Events::ApplicantStatusUpdated::Data::V2.new(
      job_id:,
      applicant_id: applicant_id3,
      applicant_first_name: "Hannah",
      applicant_last_name: "Block",
      applicant_email: "hannah@hannah.com",
      applicant_phone_number: "1234567890",
      employer_name: employer_name2,
      seeker_id: other_seeker_id,
      user_id: other_user_id,
      employment_title: employment_title2,
      status: status1
    )
  end

  let(:barrier1) { create(:barrier, name: "barrier1") }
  let(:barrier2) { create(:barrier, name: "barrier2") }

  let(:time1) { Time.utc(2020, 1, 1) }
  let(:time2) { Time.utc(2022, 1, 1) }
  let(:employment_title1) { "A place of employment" }
  let(:employment_title2) { "Another place of employment" }
  let(:status1) { "pending intro" }
  let(:status2) { "hire" }
  let(:lead_id) { "91308d08-bd08-452b-a7de-74746a6c5f93" }
  let(:coach_user_id) { create(:coaches__coach).coach_id }
  let(:user_without_email_id) { "4f878ed9-5cb9-429b-ab22-969b46305ea2" }
  let(:seeker_without_email_id) { "b09195f7-a15e-461f-bec2-1e4744122fdf" }
  let(:user_id) { "9f769972-c41c-4b58-a056-bffb714ea24d" }
  let(:other_user_id) { "7a381c1e-6f1c-41e7-b045-6f989acc2cf8" }
  let(:seeker_id) { "75372772-49dc-4884-b4ae-1d408e030aa4" }
  let(:other_seeker_id) { "2dc66599-1116-4d7a-bdbb-38652fbed6cd" }
  let(:note_id1) { "78f22f6c-a770-46fc-a83c-1ad6cda4b8f9" }
  let(:note_id2) { "a0c1894f-df0d-40d3-bb1d-d68efea4772d" }
  let(:applicant_id1) { "8aac8c6d-5c13-418d-b8e7-fd468fa291de" }
  let(:applicant_id2) { "749d43ba-08b5-40cb-977c-4e8ebd2da04a" }
  let(:applicant_id3) { "71f36a32-9c83-47e7-a22a-3d15b03c2dc0" }
  let(:job_id) { create(:coaches__job).job_id }
  let(:updated_note) { "This note was updated" }
  let(:employer_name1) { "Cool company" }
  let(:employer_name2) { "Fun company" }

  before do
    described_class.handle_event(lead_added)
    described_class.handle_event(non_seeker_user_created)
    described_class.handle_event(user_without_email)
    described_class.handle_event(seeker_without_email)
    described_class.handle_event(user_created)
    described_class.handle_event(user_updated)
    described_class.handle_event(other_user_created)
    described_class.handle_event(seeker_created)
    described_class.handle_event(other_seeker_created)
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
    described_class.handle_event(barriers_updated1)
    described_class.handle_event(barriers_updated2)
    described_class.handle_event(job_recommended)
  end

  it_behaves_like "an event consumer"

  describe ".reset_for_replay" do
    subject { described_class.reset_for_replay }

    it "destroys all records" do
      expect(Coaches::CoachSeekerContext.count).not_to eq(0)
      expect(Coaches::SeekerLead.count).not_to eq(0)
      expect(Coaches::SeekerApplication.count).not_to eq(0)
      expect(Coaches::SeekerNote.count).not_to eq(0)
      expect(Coaches::SeekerJobRecommendation.count).not_to eq(0)
      expect(Coaches::SeekerBarrier.count).not_to eq(0)

      subject

      expect(Coaches::CoachSeekerContext.count).to eq(0)
      expect(Coaches::SeekerLead.count).to eq(0)
      expect(Coaches::SeekerApplication.count).to eq(0)
      expect(Coaches::SeekerNote.count).to eq(0)
      expect(Coaches::SeekerJobRecommendation.count).to eq(0)
      expect(Coaches::SeekerBarrier.count).to eq(0)
    end
  end

  describe ".all_contexts" do
    subject { described_class.all_contexts }

    it "returns all profiles" do
      expected_profile = {
        seekerId: seeker_id,
        firstName: "Hannah",
        lastName: "Block",
        email: "hannah@blocktrainapp.com",
        phoneNumber: "1234567890",
        skillLevel: 'advanced',
        lastActiveOn: applicant_status_updated3.occurred_at,
        lastContacted: note_with_id_added1.occurred_at,
        assignedCoach: coach_user_id,
        barriers: [{
          id: barrier2.barrier_id,
          name: "barrier2"
        }],
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
        job_recommendations: [job_id],
        stage: 'seeker_created'
      }
      expected_other_profile = {
        seekerId: other_seeker_id,
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
        job_recommendations: [],
        stage: 'seeker_created'
      }

      expect(subject).to include(expected_profile)
      expect(subject).to include(expected_other_profile)
    end
  end

  describe ".all_leads" do
    subject { described_class.all_leads }

    it "returns all profiles" do
      expected_lead = {
        phone_number: "1234567890",
        first_name: "Hannah",
        last_name: "Block",
        lead_captured_at: time1,
        email: nil,
        lead_captured_by: "khall@blocktrainapp.com",
        status: Coaches::SeekerLead::StatusTypes::CONVERTED
      }

      expect(subject).to contain_exactly(expected_lead)
    end
  end

  describe ".find_context" do
    subject { described_class.find_context(seeker_id) }

    it "returns the profile" do
      expected_profile = {
        seekerId: seeker_id,
        firstName: "Hannah",
        lastName: "Block",
        email: "hannah@blocktrainapp.com",
        phoneNumber: "1234567890",
        skillLevel: 'advanced',
        lastActiveOn: applicant_status_updated3.occurred_at,
        lastContacted: note_with_id_added1.occurred_at,
        assignedCoach: coach_user_id,
        barriers: [{
          id: barrier2.barrier_id,
          name: "barrier2"
        }],
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
        job_recommendations: [job_id],
        stage: 'seeker_created'
      }

      expect(subject).to eq(expected_profile)
    end

    context "when another events occur which update last active on" do
      [
        Events::JobSaved::V1,
        Events::JobUnsaved::V1,
        Events::SeekerUpdated::V1,
        Events::OnboardingCompleted::V1
      ].each do |event_schema|
        context "when a #{event_schema.event_type} version #{event_schema.version} occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :events__message,
              event_type: event_schema.event_type,
              version: event_schema.version,
              aggregate_id: user_id,
              occurred_at: time2
            )

            described_class.handle_event(message)

            expect(subject[:lastActiveOn]).to eq(time2)
          end
        end
      end

      context "when a personal_experience_created version 1 occurs for a seeker" do
        it "updates the last active to when the event occured" do
          message = build(
            :events__message,
            event_type: Events::PersonalExperienceCreated::V1.event_type,
            version: Events::PersonalExperienceCreated::V1.version,
            data: Events::PersonalExperienceCreated::Data::V1.new(
              id: SecureRandom.uuid,
              activity: "something",
              description: "A description",
              start_date: Time.zone.now.to_s,
              end_date: Time.zone.now.to_s,
              seeker_id: SecureRandom.uuid
            ),
            aggregate_id: user_id,
            occurred_at: time2
          )

          described_class.handle_event(message)

          expect(subject[:lastActiveOn]).to eq(time2)
        end
      end

      context "when a education_experience_created version 1 occurs for a seeker" do
        it "updates the last active to when the event occured" do
          message = build(
            :events__message,
            event_type: Events::EducationExperienceCreated::V1.event_type,
            version: Events::EducationExperienceCreated::V1.version,
            data: Events::EducationExperienceCreated::Data::V1.new(
              id: SecureRandom.uuid,
              organization_name: "Org",
              title: "A title",
              activities: nil,
              graduation_date: Time.zone.now.to_s,
              gpa: "1.9",
              seeker_id: SecureRandom.uuid
            ),
            aggregate_id: user_id,
            occurred_at: time2
          )

          described_class.handle_event(message)

          expect(subject[:lastActiveOn]).to eq(time2)
        end
      end

      context "when a job_search version 2 occurs for a seeker" do
        it "updates the last active to when the event occured" do
          message = build(
            :events__message,
            event_type: Events::JobSearch::V2.event_type,
            version: Events::JobSearch::V2.version,
            data: Events::JobSearch::Data::V1.new(
              search_terms: "A search",
              industries: [],
              tags: nil
            ),
            metadata: Events::JobSearch::MetaData::V2.new(
              source: "seeker"
            ),
            aggregate_id: user_id,
            occurred_at: time2
          )

          described_class.handle_event(message)

          expect(subject[:lastActiveOn]).to eq(time2)
        end
      end
    end
  end

  describe ".add_lead" do
    subject { described_class.add_lead(coach:, first_name:, last_name:, lead_id:, phone_number:, now:) }

    let(:coach) { create(:coaches__coach) }
    let(:first_name) { "John" }
    let(:last_name) { "Chabot" }
    let(:phone_number) { "333-333-3333" }
    let(:lead_id) { "ffc354f5-e1c3-4859-b9f0-1e94106ddc96" }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::LeadAdded::V1,
        aggregate_id: coach.id,
        data: Events::Common::UntypedHashWrapper.build(
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
    subject { described_class.add_note(id: seeker_id, coach:, note: "This is a new note", note_id: note_id1, now:) }

    let(:coach) { create(:coaches__coach) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::NoteAdded::V1,
        aggregate_id: seeker_id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note: "This is a new note",
          note_id: note_id1
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".delete_note" do
    subject { described_class.delete_note(coach:, id: seeker_id, note_id: note.note_id, now:) }

    let(:note) { create(:coaches__seeker_note, note_id: note_id1) }
    let(:coach) { create(:coaches__coach) }
    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::NoteDeleted::V1,
        aggregate_id: seeker_id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id: note_id1
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".modify_note" do
    subject { described_class.modify_note(id: seeker_id, coach:, note_id: note_id2, note: updated_note, now:) }

    let(:coach) { create(:coaches__coach) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::NoteModified::V1,
        aggregate_id: seeker_id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id: note_id2,
          note: updated_note
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".recommend_job" do
    subject { described_class.recommend_job(seeker_id:, job_id:, coach:, now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:coach) { create(:coaches__coach) }
    let(:job_id) { create(:coaches__job).job_id }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::JobRecommended::V1,
        aggregate_id: seeker_id,
        data: Events::JobRecommended::Data::V1.new(
          job_id:,
          coach_id: coach.coach_id
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".update_barriers" do
    subject { described_class.update_barriers(id: seeker_id, barriers: [barrier.barrier_id], now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }
    let(:barrier) { create(:barrier) }

    it "creates an event" do
      expect(Events::Common::UntypedHashWrapper)
        .to receive(:build)
        .with(
          barriers: [be_a(String)]
        ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::BarrierUpdated::V1,
        aggregate_id: seeker_id,
        data: be_a(Events::Common::UntypedHashWrapper),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".assign_coach" do
    subject { described_class.assign_coach(seeker_id, "123", "coach@blocktrainapp.com", now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::CoachAssigned::V1,
        aggregate_id: seeker_id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: "123",
          email: "coach@blocktrainapp.com"
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end

  describe ".update_skill_level" do
    subject { described_class.update_skill_level(seeker_id, "advanced", now:) }

    let(:now) { Time.zone.local(2020, 1, 1) }

    it "creates an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SkillLevelUpdated::V1,
        aggregate_id: seeker_id,
        data: Events::Common::UntypedHashWrapper.build(
          skill_level: "advanced"
        ),
        occurred_at: now
      ).and_call_original

      subject
    end
  end
end
