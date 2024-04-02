require 'rails_helper'

RSpec.describe Coaches::CoachesAggregator do # rubocop:disable Metrics/BlockLength
  let(:lead_added1) { build(:message, :lead_added, version: 2, aggregate_id: lead1.lead_id, data: lead1, occurred_at: time1) }
  let(:lead_added2) { build(:message, :lead_added, version: 2, aggregate_id: lead2.lead_id, data: lead2, occurred_at: time1) }
  let(:non_seeker_user_created) { build(:message, :user_created, aggregate_id: coach_user_id, data: Events::UserCreated::Data::V1.new(email: "f@f.f")) }
  let(:user_without_email) { build(:message, :user_created, aggregate_id: user_without_email_id, data: Events::UserCreated::Data::V1.new(first_name: "Hannah", last_name: "Block")) }
  let(:seeker_without_email) { build(:message, :profile_created, aggregate_id: user_without_email_id, data: Events::SeekerCreated::Data::V1.new(id: seeker_without_email_id, user_id: user_without_email_id)) }
  let(:user_created) { build(:message, :user_created, aggregate_id: user_id, data: Events::UserCreated::Data::V1.new(email: "hannah@blocktrainapp.com")) }
  let(:user_updated) { build(:message, :user_updated, aggregate_id: user_id, data: Events::UserUpdated::Data::V1.new(first_name: "Hannah", last_name: "Block", phone_number: "1234567890")) }
  let(:other_user_created) { build(:message, :user_created, aggregate_id: other_user_id, data: Events::UserCreated::Data::V1.new(email: "katina@gmail.com", first_name: "Katina", last_name: "Hall")) }
  let(:seeker_created) { build(:message, :profile_created, aggregate_id: user_id, data: Events::SeekerCreated::Data::V1.new(id: seeker_id, user_id:)) }
  let(:other_seeker_created) { build(:message, :profile_created, aggregate_id: other_user_id, data: Events::SeekerCreated::Data::V1.new(id: other_seeker_id, user_id: other_user_id)) }
  let(:note_with_id_added1) { build(:message, :note_added, version: 3, aggregate_id: lead1.lead_id, data: Events::NoteAdded::Data::V2.new(note: "This is a note with an id 1", note_id: note_id1, originator: "coach@blocktrainapp.com"), occurred_at: time1) }
  let(:note_with_id_added2) { build(:message, :note_added, version: 3, aggregate_id: lead1.lead_id, data: Events::NoteAdded::Data::V2.new(note: "This is a note with an id 2", note_id: note_id2, originator: "coach@blocktrainapp.com"), occurred_at: time1) }
  let(:applicant_status_updated1) { build(:message, :applicant_status_updated, version: 5, aggregate_id: job_id, data: status_updated1, metadata: status_metadata, occurred_at: time2) }
  let(:applicant_status_updated2) { build(:message, :applicant_status_updated, version: 5, aggregate_id: job_id, data: status_updated2, metadata: status_metadata, occurred_at: time2) }
  let(:applicant_status_updated3) { build(:message, :applicant_status_updated, version: 5, aggregate_id: job_id, data: status_updated3, metadata: status_metadata, occurred_at: time2) }
  let(:applicant_status_updated4) { build(:message, :applicant_status_updated, version: 5, aggregate_id: job_id, data: status_updated4, metadata: status_metadata, occurred_at: time2) }
  let(:note_deleted) { build(:message, :note_deleted, version: 3, aggregate_id: lead1.lead_id, data: Events::NoteDeleted::Data::V2.new(note_id: note_id1, originator: coach.email), occurred_at: time1) }
  let(:note_modified) { build(:message, :note_modified, version: 3, aggregate_id: lead1.lead_id, data: Events::NoteModified::Data::V2.new(note: updated_note, note_id: note_id2, originator: coach.email), occurred_at: time1) }
  let(:skill_level_updated) { build(:message, :skill_level_updated, version: 2, aggregate_id: lead1.lead_id, data: Events::SkillLevelUpdated::Data::V1.new(skill_level: "advanced"), occurred_at: time1) }
  let(:coach_assigned) { build(:message, :coach_assigned, version: 2, aggregate_id: lead1.lead_id, data: Events::CoachAssigned::Data::V1.new(coach_id:, email: "coach@blocktrainapp.com"), occurred_at: time1) }
  let(:barriers_updated1) { build(:message, :barriers_updated, version: 2, aggregate_id: lead1.lead_id, data: Events::BarrierUpdated::Data::V1.new(barriers: [barrier1.barrier_id]), occurred_at: time1) }
  let(:barriers_updated2) { build(:message, :barriers_updated, version: 2, aggregate_id: lead1.lead_id, data: Events::BarrierUpdated::Data::V1.new(barriers: [barrier2.barrier_id]), occurred_at: time1) }
  let(:job_recommended) { build(:message, :job_recommended, version: 2, aggregate_id: lead1.lead_id, data: Events::JobRecommended::Data::V1.new(job_id:, coach_id:), occurred_at: time1) }
  let(:seeker_certified) { build(:message, :seeker_certified, aggregate_id: seeker_id, data: Events::SeekerCertified::Data::V1.new(coach_id:, coach_email: coach.email), occurred_at: time1) }

  let(:lead1) do
    Events::LeadAdded::Data::V1.new(
      email: "hannah@blocktrainapp.com",
      lead_id: "eaa9b128-4285-4ae9-abb1-9fd548a5b9d5",
      phone_number: "1234567890",
      first_name: "Hannah",
      last_name: "Block",
      lead_captured_by: "khall@blocktrainapp.com"
    )
  end
  let(:lead2) do
    Events::LeadAdded::Data::V1.new(
      email: nil,
      lead_id: "8628daea-7af8-41d1-b5b4-456336a7ed61",
      phone_number: "0987654321",
      first_name: "Not",
      last_name: "Converted",
      lead_captured_by: "someone@skillarc.com"
    )
  end
  let(:status_updated1) do
    Events::ApplicantStatusUpdated::Data::V4.new(
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
    Events::ApplicantStatusUpdated::Data::V4.new(
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
    Events::ApplicantStatusUpdated::Data::V4.new(
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
    Events::ApplicantStatusUpdated::Data::V4.new(
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
  let(:status_metadata) do
    Events::ApplicantStatusUpdated::MetaData::V1.new
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
  let(:coach) { create(:coaches__coach) }
  let(:coach_id) { coach.coach_id }
  let(:coach_user_id) { coach.user_id }
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
  let(:consumer) { described_class.new(event_service: EventService.new) }

  let(:id) { SecureRandom.uuid }

  it_behaves_like "a message consumer"

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is barrier_added" do
      let(:message) do
        build(
          :message,
          schema: Events::BarrierAdded::V1,
          data: {
            barrier_id: id,
            name: "A lame barrier"
          }
        )
      end

      it "Creates a barrier record" do
        expect { subject }.to change {
          Barrier.count
        }.from(0).to(1)

        barrier = Barrier.last_created
        expect(barrier.barrier_id).to eq(id)
        expect(barrier.name).to eq("A lame barrier")
      end
    end

    context "when the message is role_added" do
      let(:message) do
        build(
          :message,
          schema: Events::RoleAdded::V1,
          data: {
            role:,
            email: "some@email.com",
            coach_id: id
          }
        )
      end

      context "when the role is not 'coach'" do
        let(:role) { Role::Types::EMPLOYER_ADMIN }

        it "does nothing" do
          expect { subject }.not_to(change do
                                      Coaches::Coach.count
                                    end)
        end
      end

      context "when the role is 'coach'" do
        let(:role) { Role::Types::COACH }

        it "Creates a coach record" do
          expect { subject }.to change {
            Coaches::Coach.count
          }.from(0).to(1)

          coach = Coaches::Coach.last_created
          expect(coach.email).to eq("some@email.com")
          expect(coach.coach_id).to eq(id)
        end
      end
    end

    context "when the message is job_created" do
      let(:message) do
        build(
          :message,
          aggregate_id: id,
          schema: Events::JobCreated::V3,
          data: {
            category: Job::Categories::MARKETPLACE,
            employment_title: "Laborer",
            employer_name: "Employer",
            employer_id: SecureRandom.uuid,
            benefits_description: "Benefits",
            responsibilities_description: "Responsibilities",
            location: "Columbus, OH",
            employment_type: "FULLTIME",
            hide_job: false,
            schedule: "9-5",
            work_days: "M-F",
            requirements_description: "Requirements",
            industry: [Job::Industries::MANUFACTURING]
          }
        )
      end

      it "Creates a job record" do
        expect { subject }.to change {
          Coaches::Job.count
        }.from(0).to(1)

        job = Coaches::Job.last_created
        expect(job.job_id).to eq(id)
        expect(job.employment_title).to eq("Laborer")
        expect(job.employer_name).to eq("Employer")
        expect(job.hide_job).to eq(false)
      end
    end

    context "for coach seekers context" do
      let!(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

      context "when the message is applicant_status_updated" do
        let(:message) do
          build(
            :message,
            schema: Events::ApplicantStatusUpdated::V5,
            data: {
              job_id:,
              applicant_id:,
              applicant_first_name: "Hannah",
              applicant_last_name: "Block",
              applicant_email: "hannah@hannah.com",
              applicant_phone_number: "1234567890",
              employer_name: "Employer",
              seeker_id: coach_seeker_context.seeker_id,
              user_id: coach_seeker_context.user_id,
              employment_title: "Software Engineer",
              status: ApplicantStatus::StatusTypes::NEW
            },
            metadata: {}
          )
        end
        let(:job_id) { SecureRandom.uuid }
        let(:applicant_id) { SecureRandom.uuid }

        it "Creates a feed event" do
          expect { subject }.to change {
            Coaches::FeedEvent.count
          }.from(0).to(1)

          feed_event = Coaches::FeedEvent.last_created
          expect(feed_event.context_id).to eq(coach_seeker_context.context_id)
          expect(feed_event.occurred_at).to eq(message.occurred_at)
          expect(feed_event.seeker_email).to eq("hannah@hannah.com")
          expect(feed_event.description).to eq("Hannah Block's application for Software Engineer at Employer has been updated to new.")
        end

        context "when there is an existing seeker application" do
          before do
            create(
              :coaches__seeker_application,
              coach_seeker_context:,
              application_id: applicant_id
            )
          end

          it "Update the seeker application" do
            expect { subject }.not_to(change do
              Coaches::SeekerApplication.count
            end)

            seeker_applications = Coaches::SeekerApplication.last_created
            expect(seeker_applications.status).to eq(ApplicantStatus::StatusTypes::NEW)
            expect(seeker_applications.employer_name).to eq("Employer")
            expect(seeker_applications.job_id).to eq(job_id)
            expect(seeker_applications.employment_title).to eq("Software Engineer")
          end
        end

        context "when there isn't an existing seeker application" do
          it "Creates the seeker application" do
            expect { subject }.to change {
                                    Coaches::SeekerApplication.count
                                  }.from(0).to(1)

            seeker_applications = Coaches::SeekerApplication.last_created
            expect(seeker_applications.status).to eq(ApplicantStatus::StatusTypes::NEW)
            expect(seeker_applications.employer_name).to eq("Employer")
            expect(seeker_applications.job_id).to eq(job_id)
            expect(seeker_applications.employment_title).to eq("Software Engineer")
          end
        end
      end
    end
  end

  describe "existing tests" do
    before do
      consumer.handle_message(lead_added1)
      consumer.handle_message(lead_added2)
      consumer.handle_message(non_seeker_user_created)
      consumer.handle_message(user_without_email)
      consumer.handle_message(seeker_without_email)
      consumer.handle_message(user_created)
      consumer.handle_message(user_updated)
      consumer.handle_message(other_user_created)
      consumer.handle_message(seeker_created)
      consumer.handle_message(other_seeker_created)
      consumer.handle_message(note_with_id_added1)
      consumer.handle_message(note_with_id_added2)
      consumer.handle_message(note_deleted)
      consumer.handle_message(note_modified)
      consumer.handle_message(skill_level_updated)
      consumer.handle_message(coach_assigned)
      consumer.handle_message(applicant_status_updated1)
      consumer.handle_message(applicant_status_updated2)
      consumer.handle_message(applicant_status_updated3)
      consumer.handle_message(applicant_status_updated4)
      consumer.handle_message(barriers_updated1)
      consumer.handle_message(barriers_updated2)
      consumer.handle_message(job_recommended)
      consumer.handle_message(seeker_certified)
    end

    describe ".reset_for_replay" do
      subject { consumer.reset_for_replay }

      it "destroys all records" do
        expect(Coaches::CoachSeekerContext.count).not_to eq(0)
        expect(Coaches::SeekerApplication.count).not_to eq(0)
        expect(Coaches::SeekerNote.count).not_to eq(0)
        expect(Coaches::SeekerJobRecommendation.count).not_to eq(0)
        expect(Coaches::SeekerBarrier.count).not_to eq(0)
        expect(Barrier.count).not_to eq(0)
        expect(Coaches::Coach.count).not_to eq(0)
        expect(Coaches::Job.count).not_to eq(0)
        expect(Coaches::FeedEvent.count).not_to eq(0)

        subject

        expect(Coaches::CoachSeekerContext.count).to eq(0)
        expect(Coaches::SeekerApplication.count).to eq(0)
        expect(Coaches::SeekerNote.count).to eq(0)
        expect(Coaches::SeekerJobRecommendation.count).to eq(0)
        expect(Coaches::SeekerBarrier.count).to eq(0)
        expect(Barrier.count).to eq(0)
        expect(Coaches::Job.count).to eq(0)
        expect(Coaches::FeedEvent.count).to eq(0)
      end
    end

    describe ".all_seekers" do
      subject { Coaches::CoachesQuery.all_seekers }

      it "returns all profiles" do
        expected_profile = {
          id: lead1.lead_id,
          seeker_id:,
          first_name: "Hannah",
          last_name: "Block",
          kind: 'seeker',
          email: "hannah@blocktrainapp.com",
          phone_number: "1234567890",
          skill_level: 'advanced',
          last_active_on: applicant_status_updated3.occurred_at,
          last_contacted: note_with_id_added1.occurred_at,
          assigned_coach: "coach@blocktrainapp.com",
          certified_by: coach.email,
          barriers: [{
            id: barrier2.barrier_id,
            name: "barrier2"
          }],
          notes: [
            {
              note: "This note was updated",
              note_id: note_id2,
              note_taken_by: "coach@blocktrainapp.com",
              date: Time.utc(2020, 1, 1)
            }
          ],
          applications: [
            {
              job_id:,
              employer_name: employer_name2,
              status: status1,
              employment_title: employment_title2
            }
          ],
          job_recommendations: [job_id]
        }
        expected_other_profile = {
          id: other_user_id,
          seeker_id: other_seeker_id,
          first_name: "Katina",
          last_name: "Hall",
          kind: 'seeker',
          email: "katina@gmail.com",
          phone_number: nil,
          skill_level: 'beginner',
          last_active_on: applicant_status_updated4.occurred_at,
          last_contacted: "Never",
          assigned_coach: 'none',
          certified_by: nil,
          barriers: [],
          notes: [],
          applications: [
            {
              job_id:,
              employer_name: employer_name1,
              status: status2,
              employment_title: employment_title1
            },
            {
              job_id:,
              employer_name: employer_name2,
              status: status1,
              employment_title: employment_title2
            }
          ],
          job_recommendations: []
        }

        expect(subject).to include(expected_profile)
        expect(subject).to include(expected_other_profile)
      end
    end

    describe ".all_leads" do
      subject { Coaches::CoachesQuery.all_leads }

      it "returns all non-coverted leads" do
        expected_lead = {
          id: "8628daea-7af8-41d1-b5b4-456336a7ed61",
          phone_number: "0987654321",
          assigned_coach: 'none',
          first_name: "Not",
          last_name: "Converted",
          lead_captured_at: time1,
          email: nil,
          lead_captured_by: "someone@skillarc.com",
          kind: Coaches::CoachSeekerContext::Kind::LEAD,
          status: "new"
        }

        expect(subject).to contain_exactly(expected_lead)
      end
    end

    describe ".find_context" do
      subject { Coaches::CoachesQuery.find_context(lead1.lead_id) }

      it "returns the seeker" do
        expected_profile = {
          id: lead1.lead_id,
          seeker_id:,
          first_name: "Hannah",
          last_name: "Block",
          kind: 'seeker',
          email: "hannah@blocktrainapp.com",
          phone_number: "1234567890",
          skill_level: 'advanced',
          last_active_on: applicant_status_updated3.occurred_at,
          last_contacted: note_with_id_added1.occurred_at,
          assigned_coach: "coach@blocktrainapp.com",
          certified_by: coach.email,
          barriers: [{
            id: barrier2.barrier_id,
            name: "barrier2"
          }],
          notes: [
            {
              note: "This note was updated",
              note_taken_by: "coach@blocktrainapp.com",
              date: Time.utc(2020, 1, 1),
              note_id: note_id2
            }
          ],
          applications: [
            {
              status: status1,
              job_id:,
              employment_title: employment_title2,
              employer_name: employer_name2
            }
          ],
          job_recommendations: [job_id]
        }

        expect(subject).to eq(expected_profile)
      end

      context "when another events occur which update last active on" do
        context "when a onboarding complete version 1 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::OnboardingCompleted::V1.message_type,
              version: Events::OnboardingCompleted::V1.version,
              data: Events::OnboardingCompleted::Data::V1.new(
                name: {},
                experience: nil,
                education: nil,
                trainingProvider: nil,
                other: nil,
                opportunityInterests: nil
              ),
              aggregate_id: user_id,
              occurred_at: time2
            )

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end

        context "when a job_saved version 1 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::JobSaved::V1.message_type,
              version: Events::JobSaved::V1.version,
              data: Events::JobSaved::Data::V1.new(
                job_id: SecureRandom.uuid,
                employment_title: "A",
                employer_name: "B"
              ),
              aggregate_id: user_id,
              occurred_at: time2
            )

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end

        context "when a job_unsaved version 1 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::JobUnsaved::V1.message_type,
              version: Events::JobUnsaved::V1.version,
              data: Events::JobUnsaved::Data::V1.new(
                job_id: SecureRandom.uuid,
                employment_title: "A",
                employer_name: "B"
              ),
              aggregate_id: user_id,
              occurred_at: time2
            )

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end

        context "when a education_experience_created version 1 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::EducationExperienceCreated::V1.message_type,
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

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end

        context "when a seeker_updated version 1 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::SeekerUpdated::V1.message_type,
              version: Events::SeekerUpdated::V1.version,
              data: Events::SeekerUpdated::Data::V1.new(
                about: "A new about"
              ),
              aggregate_id: seeker_id,
              occurred_at: time2
            )

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end

        context "when a personal_experience_created version 1 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::PersonalExperienceCreated::V1.message_type,
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

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end

        context "when a job_search version 2 occurs for a seeker" do
          it "updates the last active to when the event occured" do
            message = build(
              :message,
              message_type: Events::JobSearch::V2.message_type,
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

            consumer.handle_message(message)

            expect(subject[:last_active_on]).to eq(time2)
          end
        end
      end
    end
  end
end
