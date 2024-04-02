require 'rails_helper'

RSpec.describe Coaches::CoachesQuery do
  describe ".all_seekers" do
    subject { described_class.all_seekers }

    before do
      csc1 = create(
        :coaches__coach_seeker_context,
        context_id: "07f0f251-599a-4b59-920f-5b2054f32ca2",
        seeker_id: "ab36d8fe-5bf0-47c3-9c79-fc461799287e",
        phone_number: "1234567890",
        first_name: "Hannah",
        last_name: "Block",
        assigned_coach: "coach@blocktrainapp.com",
        seeker_captured_at: Time.zone.local(2000, 1, 1),
        skill_level: "advanced",
        email: "hannah@blocktrainapp.com",
        lead_captured_by: "someone@skillarc.com",
        last_active_on: Time.zone.local(2005, 1, 1),
        last_contacted_at: Time.zone.local(2010, 1, 1),
        kind: Coaches::CoachSeekerContext::Kind::SEEKER,
        certified_by: "person@skillarc.com"
      )

      csc2 = create(
        :coaches__coach_seeker_context,
        context_id: "1a8d105a-6b9a-4842-ab02-8daf3fcb0c1f",
        seeker_id: "3e7cccaa-ec0e-4c59-a7ad-2b187b3acc4c",
        phone_number: nil,
        first_name: "Katina",
        last_name: "Hall",
        assigned_coach: nil,
        seeker_captured_at: Time.zone.local(2001, 1, 1),
        skill_level: "beginner",
        email: "katina@gmail.com",
        lead_captured_by: "someone@skillarc.com",
        last_active_on: Time.zone.local(2008, 1, 1),
        last_contacted_at: nil,
        kind: Coaches::CoachSeekerContext::Kind::SEEKER,
        certified_by: nil
      )

      create(
        :coaches__coach_seeker_context,
        context_id: "ec9ea4ff-7655-435b-a6dc-0de8427d6cb6",
        phone_number: "1234567890",
        first_name: "Jim",
        last_name: "Jimson",
        assigned_coach: nil,
        seeker_captured_at: Time.zone.local(2000, 1, 1),
        skill_level: "advanced",
        email: "hannah@blocktrainapp.com",
        lead_captured_by: "someone@skillarc.com",
        last_active_on: Time.zone.local(2005, 1, 1),
        last_contacted_at: Time.zone.local(2010, 1, 1),
        kind: Coaches::CoachSeekerContext::Kind::LEAD,
        certified_by: "person@skillarc.com"
      )

      create(
        :coaches__seeker_barrier,
        coach_seeker_context: csc1,
        barrier: create(
          :barrier,
          barrier_id: "81f43abc-67b6-4531-af45-293d3fc053e5",
          name: "barrier2"
        )
      )

      create(
        :coaches__seeker_note,
        coach_seeker_context: csc1,
        note: "This note was updated",
        note_id: "a2dd7180-6c3d-46ad-9bd7-413314b7a849",
        note_taken_at: Time.zone.local(2020, 1, 1),
        note_taken_by: "coach@blocktrainapp.com"
      )

      create(
        :coaches__seeker_application,
        coach_seeker_context: csc1,
        job_id: "2e6a7696-08e6-4e95-aa95-166fc2b43dcf",
        status: "Actively failing an interview",
        employer_name: "Cool",
        employment_title: "A title"
      )

      create(
        :coaches__seeker_application,
        coach_seeker_context: csc2,
        job_id: "23642aea-8f58-4a0c-8799-5d80591b84ad",
        status: "Actively failing an interview",
        employer_name: "Not Cool",
        employment_title: "A title"
      )

      create(
        :coaches__seeker_application,
        coach_seeker_context: csc2,
        job_id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
        status: "Actively chillin at an interview",
        employer_name: "Cool",
        employment_title: "A bad title"
      )

      create(
        :coaches__seeker_job_recommendation,
        coach_seeker_context: csc1,
        job: create(:coaches__job, job_id: "d4cd7594-bc68-44cd-b22c-246979a9ea0f")
      )
    end

    it "returns an empty array" do
      expected_profile = {
        id: "07f0f251-599a-4b59-920f-5b2054f32ca2",
        seeker_id: "ab36d8fe-5bf0-47c3-9c79-fc461799287e",
        first_name: "Hannah",
        last_name: "Block",
        kind: 'seeker',
        email: "hannah@blocktrainapp.com",
        phone_number: "1234567890",
        skill_level: 'advanced',
        last_active_on: Time.zone.local(2005, 1, 1),
        last_contacted: Time.zone.local(2010, 1, 1),
        assigned_coach: "coach@blocktrainapp.com",
        certified_by: "person@skillarc.com",
        barriers: [{
          id: "81f43abc-67b6-4531-af45-293d3fc053e5",
          name: "barrier2"
        }],
        notes: [
          {
            note: "This note was updated",
            note_id: "a2dd7180-6c3d-46ad-9bd7-413314b7a849",
            note_taken_by: "coach@blocktrainapp.com",
            date: Time.utc(2020, 1, 1)
          }
        ],
        applications: [
          {
            job_id: "2e6a7696-08e6-4e95-aa95-166fc2b43dcf",
            employer_name: "Cool",
            status: "Actively failing an interview",
            employment_title: "A title"
          }
        ],
        job_recommendations: ["d4cd7594-bc68-44cd-b22c-246979a9ea0f"]
      }
      expected_other_profile = {
        id: "1a8d105a-6b9a-4842-ab02-8daf3fcb0c1f",
        seeker_id: "3e7cccaa-ec0e-4c59-a7ad-2b187b3acc4c",
        first_name: "Katina",
        last_name: "Hall",
        kind: 'seeker',
        email: "katina@gmail.com",
        phone_number: nil,
        skill_level: 'beginner',
        last_active_on: Time.zone.local(2008, 1, 1),
        last_contacted: "Never",
        assigned_coach: 'none',
        certified_by: nil,
        barriers: [],
        notes: [],
        applications: [
          {
            job_id: "23642aea-8f58-4a0c-8799-5d80591b84ad",
            employer_name: "Not Cool",
            status: "Actively failing an interview",
            employment_title: "A title"
          },
          {
            job_id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
            employer_name: "Cool",
            status: "Actively chillin at an interview",
            employment_title: "A bad title"
          }
        ],
        job_recommendations: []
      }

      expect(subject.length).to eq(2)
      expect(subject).to include(expected_profile)
      expect(subject).to include(expected_other_profile)
    end
  end

  describe ".all_leads" do
    subject { described_class.all_leads }

    before do
      create(
        :coaches__coach_seeker_context,
        context_id: "8628daea-7af8-41d1-b5b4-456336a7ed61",
        phone_number: "0987654321",
        first_name: "Not",
        last_name: "Converted",
        assigned_coach: nil,
        seeker_captured_at: Time.zone.local(2000, 1, 1),
        email: nil,
        lead_captured_by: "someone@skillarc.com",
        kind: Coaches::CoachSeekerContext::Kind::LEAD
      )
    end

    it "returns all leads" do
      expected_lead = {
        id: "8628daea-7af8-41d1-b5b4-456336a7ed61",
        phone_number: "0987654321",
        assigned_coach: 'none',
        first_name: "Not",
        last_name: "Converted",
        email: nil,
        lead_captured_at: Time.zone.local(2000, 1, 1),
        lead_captured_by: "someone@skillarc.com",
        kind: Coaches::CoachSeekerContext::Kind::LEAD,
        status: "new"
      }

      expect(subject).to eq([expected_lead])
    end
  end

  describe ".find_context" do
    subject { described_class.find_context(id) }

    let(:id) { SecureRandom.uuid }

    before do
      csc1 = create(
        :coaches__coach_seeker_context,
        context_id: id,
        seeker_id: "ab36d8fe-5bf0-47c3-9c79-fc461799287e",
        phone_number: "1234567890",
        first_name: "Hannah",
        last_name: "Block",
        assigned_coach: "coach@blocktrainapp.com",
        seeker_captured_at: Time.zone.local(2000, 1, 1),
        skill_level: "advanced",
        email: "hannah@blocktrainapp.com",
        lead_captured_by: "someone@skillarc.com",
        last_active_on: Time.zone.local(2005, 1, 1),
        last_contacted_at: Time.zone.local(2010, 1, 1),
        kind: Coaches::CoachSeekerContext::Kind::SEEKER,
        certified_by: "person@skillarc.com"
      )

      create(
        :coaches__seeker_barrier,
        coach_seeker_context: csc1,
        barrier: create(
          :barrier,
          barrier_id: "81f43abc-67b6-4531-af45-293d3fc053e5",
          name: "barrier2"
        )
      )

      create(
        :coaches__seeker_note,
        coach_seeker_context: csc1,
        note: "This note was updated",
        note_id: "a2dd7180-6c3d-46ad-9bd7-413314b7a849",
        note_taken_at: Time.zone.local(2020, 1, 1),
        note_taken_by: "coach@blocktrainapp.com"
      )

      create(
        :coaches__seeker_application,
        coach_seeker_context: csc1,
        job_id: "2e6a7696-08e6-4e95-aa95-166fc2b43dcf",
        status: "Actively failing an interview",
        employer_name: "Cool",
        employment_title: "A title"
      )

      create(
        :coaches__seeker_job_recommendation,
        coach_seeker_context: csc1,
        job: create(:coaches__job, job_id: "d4cd7594-bc68-44cd-b22c-246979a9ea0f")
      )
    end

    it "returns the context" do
      expected_profile = {
        id:,
        seeker_id: "ab36d8fe-5bf0-47c3-9c79-fc461799287e",
        first_name: "Hannah",
        last_name: "Block",
        kind: 'seeker',
        email: "hannah@blocktrainapp.com",
        phone_number: "1234567890",
        skill_level: 'advanced',
        last_active_on: Time.zone.local(2005, 1, 1),
        last_contacted: Time.zone.local(2010, 1, 1),
        assigned_coach: "coach@blocktrainapp.com",
        certified_by: "person@skillarc.com",
        barriers: [{
          id: "81f43abc-67b6-4531-af45-293d3fc053e5",
          name: "barrier2"
        }],
        notes: [
          {
            note: "This note was updated",
            note_id: "a2dd7180-6c3d-46ad-9bd7-413314b7a849",
            note_taken_by: "coach@blocktrainapp.com",
            date: Time.utc(2020, 1, 1)
          }
        ],
        applications: [
          {
            job_id: "2e6a7696-08e6-4e95-aa95-166fc2b43dcf",
            employer_name: "Cool",
            status: "Actively failing an interview",
            employment_title: "A title"
          }
        ],
        job_recommendations: ["d4cd7594-bc68-44cd-b22c-246979a9ea0f"]
      }

      expect(subject).to eq(expected_profile)
    end
  end

  describe ".all_barriers" do
    subject { described_class.all_barriers }

    before do
      create(
        :barrier,
        barrier_id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
        name: "barrier1"
      )
    end

    it "returns all barriers" do
      expected_barriers = [
        {
          id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
          name: "barrier1"
        }
      ]

      expect(subject).to eq(expected_barriers)
    end
  end

  describe ".all_coaches" do
    subject { described_class.all_coaches }

    before do
      create(
        :coaches__coach,
        coach_id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
        email: "an@email.com"
      )
    end

    it "returns all coaches" do
      expected_coaches = [
        {
          id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
          email: "an@email.com"
        }
      ]

      expect(subject).to eq(expected_coaches)
    end
  end

  describe ".all_jobs" do
    subject { described_class.all_jobs }

    before do
      create(
        :coaches__job,
        job_id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
        employer_name: "SkillArc",
        employment_title: "First Engineer"
      )

      create(
        :coaches__job,
        hide_job: true
      )
    end

    it "returns all visible jobs" do
      expected_jobs = [
        {
          id: "6f6dc17a-1f3b-44b6-aa5f-25da193943c5",
          employer_name: "SkillArc",
          employment_title: "First Engineer"
        }
      ]

      expect(subject).to eq(expected_jobs)
    end
  end
end
