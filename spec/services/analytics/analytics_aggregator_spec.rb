require 'rails_helper'

RSpec.describe Analytics::AnalyticsAggregator do # rubocop:disable Metrics/BlockLength
  describe "#handle_message" do # rubocop:disable Metrics/BlockLength
    subject { described_class.new.handle_message(message) }

    describe "when the message is lead_added" do
      let(:message) do
        build(
          :message,
          schema: Events::LeadAdded::V2,
          data: {
            email: "an@email.com",
            lead_id: SecureRandom.uuid,
            phone_number: Faker::PhoneNumber.phone_number,
            first_name: "John",
            last_name: "Chabot",
            lead_captured_by: "netsanet@chevers.com"
          }
        )
      end

      context "when there is an existing dim person for the lead email" do
        before do
          create(
            :analytics__dim_person,
            email: message.data.email
          )
        end

        it "does nothing" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)
        end
      end

      context "when there is an existing dim person for the lead phone_number" do
        before do
          create(
            :analytics__dim_person,
            phone_number: message.data.phone_number
          )
        end

        it "does nothing" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)
        end
      end

      context "when there is not an existing lead for the provided info" do
        it "creates a dim person from the message" do
          expect { subject }.to change(Analytics::DimPerson, :count).from(0).to(1)

          person = Analytics::DimPerson.take(1).first

          expect(person.lead_id).to eq(message.data.lead_id)
          expect(person.lead_created_at).to eq(message.occurred_at)
          expect(person.phone_number).to eq(message.data.phone_number)
          expect(person.email).to eq(message.data.email)
          expect(person.first_name).to eq(message.data.first_name)
          expect(person.last_name).to eq(message.data.last_name)
          expect(person.kind).to eq(Analytics::DimPerson::Kind::LEAD)
        end
      end

      context "when lead_captured_by cooresponds to a dim person" do
        let!(:dim_person_executor) { create(:analytics__dim_person, email: message.data.lead_captured_by) }

        it "creates a fact coach action record" do
          expect { subject }.to change(Analytics::FactCoachAction, :count).from(0).to(1)

          fact_coach_action = Analytics::FactCoachAction.take(1).first

          expect(fact_coach_action.dim_person_target).not_to eq(dim_person_executor)
          expect(fact_coach_action.dim_person_target).to be_a(Analytics::DimPerson)
          expect(fact_coach_action.dim_person_executor).to eq(dim_person_executor)
          expect(fact_coach_action.action_taken_at).to eq(message.occurred_at)
          expect(fact_coach_action.action).to eq(Analytics::FactCoachAction::Actions::LEAD_ADDED)
        end
      end
    end

    describe "when the message is user_created" do
      let(:message) do
        build(
          :message,
          schema: Events::UserCreated::V1,
          aggregate_id: user_id,
          data: {
            email: "an@email.com",
            first_name: "John",
            last_name: "Chabot"
          }
        )
      end
      let(:user_id) { SecureRandom.uuid }

      context "when the user is created without an email" do
        let(:email) { nil }

        it "creates a dim person from the message" do
          expect { subject }.to change(Analytics::DimPerson, :count).from(0).to(1)

          person = Analytics::DimPerson.take(1).first

          expect(person.last_active_at).to eq(message.occurred_at)
          expect(person.user_created_at).to eq(message.occurred_at)
          expect(person.email).to eq(message.data.email)
          expect(person.first_name).to eq(message.data.first_name)
          expect(person.last_name).to eq(message.data.last_name)
          expect(person.kind).to eq(Analytics::DimPerson::Kind::USER)
        end
      end

      context "when the user is created with an email" do
        let(:email) { "an@email.com" }

        context "when there is an existing dim person for the user email" do
          before do
            create(
              :analytics__dim_person,
              :user,
              email: message.data.email
            )
          end

          it "updates a dim person from the message" do
            expect { subject }.not_to change(Analytics::DimPerson, :count)

            person = Analytics::DimPerson.take(1).first

            expect(person.last_active_at).to eq(message.occurred_at)
            expect(person.user_created_at).to eq(message.occurred_at)
            expect(person.user_id).to eq(user_id)
            expect(person.email).to eq(message.data.email)
            expect(person.first_name).to eq(message.data.first_name)
            expect(person.last_name).to eq(message.data.last_name)
            expect(person.kind).to eq(Analytics::DimPerson::Kind::USER)
          end
        end

        context "when there is not an existing lead for the provided info" do
          it "creates a dim person from the message" do
            expect { subject }.to change(Analytics::DimPerson, :count).from(0).to(1)

            person = Analytics::DimPerson.take(1).first

            expect(person.last_active_at).to eq(message.occurred_at)
            expect(person.user_created_at).to eq(message.occurred_at)
            expect(person.email).to eq(message.data.email)
            expect(person.first_name).to eq(message.data.first_name)
            expect(person.last_name).to eq(message.data.last_name)
            expect(person.kind).to eq(Analytics::DimPerson::Kind::USER)
          end
        end
      end
    end

    context "for an existing dim_person" do
      before do
        create(
          :analytics__dim_person,
          :user,
          user_id:,
          email:
        )
      end

      let(:user_id) { SecureRandom.uuid }
      let(:email) { Faker::Internet.email }

      describe "when the message is user_updated" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::UserUpdated::V1,
            data: {
              email:,
              first_name: "John",
              last_name: "Chabot",
              phone_number: "333-333-444"
            }
          )
        end

        context "when email is defined" do
          let(:email) { "some@email.com" }

          it "updates a dim person from the message" do
            expect { subject }.not_to change(Analytics::DimPerson, :count)

            person = Analytics::DimPerson.take(1).first

            expect(person.last_active_at).to eq(message.occurred_at)
            expect(person.email).to eq(message.data.email)
            expect(person.phone_number).to eq(message.data.phone_number)
            expect(person.first_name).to eq(message.data.first_name)
            expect(person.last_name).to eq(message.data.last_name)
          end
        end

        context "when email is undefined" do
          let(:email) { Messages::UNDEFINED }

          it "updates a dim person from the message" do
            expect { subject }.not_to change(Analytics::DimPerson, :count)

            person = Analytics::DimPerson.take(1).first

            expect(person.last_active_at).to eq(message.occurred_at)
            expect(person.email).not_to eq(message.data.email)
            expect(person.phone_number).to eq(message.data.phone_number)
            expect(person.first_name).to eq(message.data.first_name)
            expect(person.last_name).to eq(message.data.last_name)
          end
        end
      end

      describe "when the message is seeker_created" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::SeekerCreated::V1,
            data: {
              id: seeker_id,
              user_id:
            }
          )
        end
        let(:seeker_id) { SecureRandom.uuid }

        it "updates a dim person from the message" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)

          person = Analytics::DimPerson.take(1).first

          expect(person.last_active_at).to eq(message.occurred_at)
          expect(person.seeker_id).to eq(seeker_id)
          expect(person.kind).to eq(Analytics::DimPerson::Kind::SEEKER)
        end
      end

      describe "when the message is onboarding_completed" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::OnboardingCompleted::V1,
            data: {}
          )
        end

        it "updates a dim person from message" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)

          person = Analytics::DimPerson.take(1).first

          expect(person.last_active_at).to eq(message.occurred_at)
          expect(person.onboarding_completed_at).to eq(message.occurred_at)
        end
      end

      describe "when the message is session_started" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::SessionStarted::V1,
            data: Messages::Nothing
          )
        end

        it "updates a dim person from the message" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)

          person = Analytics::DimPerson.take(1).first

          expect(person.last_active_at).to eq(message.occurred_at)
        end
      end

      describe "when the message is role_add" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::RoleAdded::V1,
            data: {
              role:,
              email: "an@email.com",
              coach_id: SecureRandom.uuid
            }
          )
        end

        context "when role is coach" do
          let(:role) { Role::Types::COACH }

          it "updates a dim person from the message" do
            expect { subject }.not_to change(Analytics::DimPerson, :count)

            person = Analytics::DimPerson.take(1).first

            expect(person.kind).to eq(Analytics::DimPerson::Kind::COACH)
          end
        end

        context "when role is not coach" do
          let(:role) { Role::Types::ADMIN }

          it "updates a dim person from the message" do
            expect { subject }.not_to change(Analytics::DimPerson, :count)

            person = Analytics::DimPerson.take(1).first

            expect(person.kind).to eq(Analytics::DimPerson::Kind::USER)
          end
        end
      end

      describe "when the message is employer_invite_accepted" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::EmployerInviteAccepted::V1,
            data: {
              employer_invite_id: SecureRandom.uuid,
              invite_email: email,
              employer_id: SecureRandom.uuid,
              employer_name: "something"
            }
          )
        end

        it "updates a dim person from the message" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)

          person = Analytics::DimPerson.take(1).first

          expect(person.kind).to eq(Analytics::DimPerson::Kind::RECRUITER)
        end
      end

      describe "when the message is employer_invite_accepted" do
        let(:message) do
          build(
            :message,
            aggregate_id: user_id,
            schema: Events::TrainingProviderInviteAccepted::V1,
            data: {
              invite_email: email,
              training_provider_id: SecureRandom.uuid,
              training_provider_name: "dawg"
            }
          )
        end

        it "updates a dim person from the message" do
          expect { subject }.not_to change(Analytics::DimPerson, :count)

          person = Analytics::DimPerson.take(1).first

          expect(person.kind).to eq(Analytics::DimPerson::Kind::TRAINING_PROVIDER)
        end
      end
    end

    context "when the message is job_created" do
      let(:message) do
        build(
          :message,
          schema: Events::JobCreated::V3,
          aggregate_id: job_id,
          data: {
            category: Job::Categories::MARKETPLACE,
            employment_title: "A title",
            employer_name: "An employer",
            employer_id: SecureRandom.uuid,
            benefits_description: "Bad benifits",
            responsibilities_description: nil,
            location: "Columbus Ohio",
            employment_type: Job::EmploymentTypes::FULLTIME,
            hide_job:
          }
        )
      end

      let(:job_id) { SecureRandom.uuid }
      let(:hide_job) { false }

      it "creates a dim job for the message" do
        expect { subject }.to change(Analytics::DimJob, :count).from(0).to(1)

        job = Analytics::DimJob.take(1).first

        expect(job.job_id).to eq(job_id)
        expect(job.category).to eq(message.data.category)
        expect(job.employment_title).to eq(message.data.employment_title)
        expect(job.employment_type).to eq(message.data.employment_type)
        expect(job.job_created_at).to eq(message.occurred_at)
      end

      context "when the job was created hidden" do
        let(:hide_job) { true }

        it "does not create a job visibility fact" do
          expect { subject }.not_to change(Analytics::FactJobVisibility, :count)
        end
      end

      context "when the job was created visible" do
        let(:hide_job) { false }

        it "creates a job visibility fact" do
          expect { subject }.to change(Analytics::FactJobVisibility, :count).from(0).to(1)

          fact_job_visibility = Analytics::FactJobVisibility.take(1).first
          expect(fact_job_visibility.visible_starting_at).to eq(message.occurred_at)
        end
      end
    end

    context "when the message is job_updated" do
      let(:message) do
        build(
          :message,
          schema: Events::JobUpdated::V2,
          aggregate_id: job_id,
          data: {
            category: Job::Categories::STAFFING,
            employment_title: "Another title",
            employment_type: Job::EmploymentTypes::PARTTIME,
            hide_job:
          }
        )
      end

      let!(:dim_job) do
        create(
          :analytics__dim_job,
          job_id:
        )
      end
      let(:job_id) { SecureRandom.uuid }
      let(:hide_job) { nil }

      it "update a dim job from the message" do
        expect { subject }.not_to change(Analytics::DimJob, :count)

        job = Analytics::DimJob.take(1).first

        expect(job.category).to eq(message.data.category)
        expect(job.employment_title).to eq(message.data.employment_title)
        expect(job.employment_type).to eq(message.data.employment_type)
      end

      context "when the job visiblity wasn't specified" do
        let(:hide_job) { nil }

        it "does not create a job visibility fact" do
          expect { subject }.not_to change(Analytics::FactJobVisibility, :count)
        end
      end

      context "when the job was update to be hidden" do
        let(:hide_job) { true }

        context "when there is a job visiblity fact with nil ended_at" do
          let!(:fact_job_visibility) { create(:analytics__fact_job_visibility, dim_job:) }

          it "updates the job visibility fact" do
            expect { subject }.not_to change(Analytics::FactJobVisibility, :count)

            fact_job_visibility.reload
            expect(fact_job_visibility.visible_ending_at).to eq(message.occurred_at)
          end
        end

        context "when there isn't a job visiblity fact with nil ended_at" do
          let!(:fact_job_visibility) { create(:analytics__fact_job_visibility, :hidden, dim_job:) }

          it "does not updates the job visibility fact" do
            expect { subject }.not_to change(Analytics::FactJobVisibility, :count)

            fact_job_visibility.reload
            expect(fact_job_visibility.visible_ending_at).not_to eq(message.occurred_at)
          end
        end
      end

      context "when the job was update to be visible" do
        let(:hide_job) { false }

        context "when there is a job visiblity fact with nil ended_at" do
          let!(:fact_job_visibility) { create(:analytics__fact_job_visibility, dim_job:) }

          it "does not update the job visibility fact" do
            expect { subject }.not_to change(Analytics::FactJobVisibility, :count)

            fact_job_visibility.reload
            expect(fact_job_visibility.visible_ending_at).to eq(nil)
          end
        end

        context "when there isn't a job visiblity fact with nil ended_at" do
          let!(:fact_job_visibility) { create(:analytics__fact_job_visibility, :hidden, dim_job:) }

          it "creates a new job visibility fact with the new starting_at" do
            expect { subject }.to change(Analytics::FactJobVisibility, :count).from(1).to(2)

            new_fact_job_visibility = Analytics::FactJobVisibility.where.not(id: fact_job_visibility.id).take(1).first
            expect(new_fact_job_visibility.visible_starting_at).to eq(message.occurred_at)
          end
        end
      end
    end

    context "when the message is applicant_status_updated" do
      let(:message) do
        build(
          :message,
          schema: Events::ApplicantStatusUpdated::V5,
          aggregate_id: job_id,
          data: {
            applicant_id: application_id,
            applicant_first_name: "John",
            applicant_last_name: "Wexner",
            applicant_email: Faker::Internet.email,
            applicant_phone_number: Faker::PhoneNumber.phone_number,
            seeker_id:,
            user_id: SecureRandom.uuid,
            job_id:,
            employer_name: "An employers",
            employment_title: "Best job",
            status:
          },
          metadata: {}
        )
      end

      let!(:dim_job1) { create(:analytics__dim_job) }
      let!(:dim_job2) { create(:analytics__dim_job) }
      let!(:dim_job3) { create(:analytics__dim_job) }
      let!(:dim_person) do
        create(
          :analytics__dim_person,
          :seeker,
          seeker_id:
        )
      end

      let(:application_id) { SecureRandom.uuid }
      let(:seeker_id) { SecureRandom.uuid }
      let(:job_id) { SecureRandom.uuid }
      let(:status) { ApplicantStatus::StatusTypes::NEW }

      context "If there isn't an existing application fact for the application id" do
        before do
          create(
            :analytics__fact_application,
            dim_job: dim_job1,
            dim_person:,
            application_number: 1
          )
          create(
            :analytics__fact_application,
            dim_job: dim_job2,
            dim_person:,
            application_number: 2
          )
        end

        let!(:dim_job) { create(:analytics__dim_job, job_id:) }

        it "creates a new application" do
          expect { subject }.to change(Analytics::FactApplication, :count).from(2).to(3)

          fact_application = Analytics::FactApplication.find_by!(application_id:)

          expect(fact_application.dim_job).to eq(dim_job)
          expect(fact_application.dim_person).to eq(dim_person)
          expect(fact_application.status).to eq(status)
          expect(fact_application.application_id).to eq(application_id)
          expect(fact_application.application_number).to eq(3)
        end
      end

      context "If there is an existing application fact for the application id" do
        before do
          create(
            :analytics__fact_application,
            dim_job: dim_job1,
            dim_person:,
            application_id:,
            application_number: 1
          )
        end

        it "creates a new application" do
          expect { subject }.not_to change(Analytics::FactApplication, :count)

          fact_application = Analytics::FactApplication.find_by!(application_id:)

          expect(fact_application.status).to eq(status)
        end
      end
    end

    context "when the message is seeker_viewed" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerViewed::V1,
          aggregate_id: user_id,
          data: {
            seeker_id:
          }
        )
      end

      let(:user_id) { SecureRandom.uuid }
      let(:seeker_id) { SecureRandom.uuid }

      let!(:dim_person_viewer) { create(:analytics__dim_person, user_id:) }
      let!(:dim_person_viewed) { create(:analytics__dim_person, seeker_id:) }

      it "creates a fact person viewed record" do
        expect { subject }.to change(Analytics::FactPersonViewed, :count).from(0).to(1)

        fact_person_viewed = Analytics::FactPersonViewed.take(1).first

        expect(fact_person_viewed.dim_person_viewed).to eq(dim_person_viewed)
        expect(fact_person_viewed.dim_person_viewer).to eq(dim_person_viewer)
        expect(fact_person_viewed.viewed_at).to eq(message.occurred_at)
        expect(fact_person_viewed.viewing_context).to eq(Analytics::FactPersonViewed::Contexts::PUBLIC_PROFILE)
      end
    end

    context "when the message is seeker_context_viewed" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerContextViewed::V1,
          aggregate_id: coach_id,
          data: {
            context_id:
          }
        )
      end

      let(:coach_id) { SecureRandom.uuid }
      let(:context_id) { SecureRandom.uuid }

      let!(:dim_person_viewer) { create(:analytics__dim_person, coach_id:) }
      let!(:dim_person_viewed) { create(:analytics__dim_person, lead_id: context_id) }

      it "creates a fact person viewed record" do
        expect { subject }.to change(Analytics::FactPersonViewed, :count).from(0).to(1)

        fact_person_viewed = Analytics::FactPersonViewed.take(1).first

        expect(fact_person_viewed.dim_person_viewed).to eq(dim_person_viewed)
        expect(fact_person_viewed.dim_person_viewer).to eq(dim_person_viewer)
        expect(fact_person_viewed.viewed_at).to eq(message.occurred_at)
        expect(fact_person_viewed.viewing_context).to eq(Analytics::FactPersonViewed::Contexts::COACHES_DASHBOARD)
      end
    end

    context "when the message is note_added" do
      let(:message) do
        build(
          :message,
          schema: Events::NoteAdded::V3,
          aggregate_id: lead_id,
          data: {
            originator: email,
            note: "Some note",
            note_id: SecureRandom.uuid
          }
        )
      end

      let(:email) { Faker::Internet.email }
      let(:lead_id) { SecureRandom.uuid }

      let!(:dim_person_executor) { create(:analytics__dim_person, email:) }
      let!(:dim_person_target) { create(:analytics__dim_person, lead_id:) }

      it "creates a fact coach action record" do
        expect { subject }.to change(Analytics::FactCoachAction, :count).from(0).to(1)

        fact_coach_action = Analytics::FactCoachAction.take(1).first

        expect(fact_coach_action.dim_person_executor).to eq(dim_person_executor)
        expect(fact_coach_action.dim_person_target).to eq(dim_person_target)
        expect(fact_coach_action.action_taken_at).to eq(message.occurred_at)
        expect(fact_coach_action.action).to eq(Analytics::FactCoachAction::Actions::NOTE_ADDED)
      end
    end

    context "when the message is note_modified" do
      let(:message) do
        build(
          :message,
          schema: Events::NoteModified::V3,
          aggregate_id: lead_id,
          data: {
            originator: email,
            note: "Some note",
            note_id: SecureRandom.uuid
          }
        )
      end

      let(:email) { Faker::Internet.email }
      let(:lead_id) { SecureRandom.uuid }

      let!(:dim_person_executor) { create(:analytics__dim_person, email:) }
      let!(:dim_person_target) { create(:analytics__dim_person, lead_id:) }

      it "creates a fact coach action record" do
        expect { subject }.to change(Analytics::FactCoachAction, :count).from(0).to(1)

        fact_coach_action = Analytics::FactCoachAction.take(1).first

        expect(fact_coach_action.dim_person_executor).to eq(dim_person_executor)
        expect(fact_coach_action.dim_person_target).to eq(dim_person_target)
        expect(fact_coach_action.action_taken_at).to eq(message.occurred_at)
        expect(fact_coach_action.action).to eq(Analytics::FactCoachAction::Actions::NOTE_MODIFIED)
      end
    end

    context "when the message is note_deleted" do
      let(:message) do
        build(
          :message,
          schema: Events::NoteDeleted::V3,
          aggregate_id: lead_id,
          data: {
            originator: email,
            note_id: SecureRandom.uuid
          }
        )
      end

      let(:email) { Faker::Internet.email }
      let(:lead_id) { SecureRandom.uuid }

      let!(:dim_person_executor) { create(:analytics__dim_person, email:) }
      let!(:dim_person_target) { create(:analytics__dim_person, lead_id:) }

      it "creates a fact coach action record" do
        expect { subject }.to change(Analytics::FactCoachAction, :count).from(0).to(1)

        fact_coach_action = Analytics::FactCoachAction.take(1).first

        expect(fact_coach_action.dim_person_executor).to eq(dim_person_executor)
        expect(fact_coach_action.dim_person_target).to eq(dim_person_target)
        expect(fact_coach_action.action_taken_at).to eq(message.occurred_at)
        expect(fact_coach_action.action).to eq(Analytics::FactCoachAction::Actions::NOTE_DELETED)
      end
    end

    context "when the message is job_recommended" do
      let(:message) do
        build(
          :message,
          schema: Events::JobRecommended::V2,
          aggregate_id: user_id,
          data: {
            job_id: SecureRandom.uuid,
            coach_id:
          }
        )
      end

      let(:coach_id) { SecureRandom.uuid }
      let(:user_id) { SecureRandom.uuid }

      let!(:dim_person_executor) { create(:analytics__dim_person, coach_id:) }
      let!(:dim_person_target) { create(:analytics__dim_person, user_id:) }

      it "creates a fact coach action record" do
        expect { subject }.to change(Analytics::FactCoachAction, :count).from(0).to(1)

        fact_coach_action = Analytics::FactCoachAction.take(1).first

        expect(fact_coach_action.dim_person_executor).to eq(dim_person_executor)
        expect(fact_coach_action.dim_person_target).to eq(dim_person_target)
        expect(fact_coach_action.action_taken_at).to eq(message.occurred_at)
        expect(fact_coach_action.action).to eq(Analytics::FactCoachAction::Actions::JOB_RECOMMENDED)
      end
    end

    context "when the message is seeker_context" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerCertified::V1,
          aggregate_id: seeker_id,
          data: {
            coach_email: Faker::Internet.email,
            coach_id:
          }
        )
      end

      let(:coach_id) { SecureRandom.uuid }
      let(:seeker_id) { SecureRandom.uuid }

      let!(:dim_person_executor) { create(:analytics__dim_person, coach_id:) }
      let!(:dim_person_target) { create(:analytics__dim_person, seeker_id:) }

      it "creates a fact coach action record" do
        expect { subject }.to change(Analytics::FactCoachAction, :count).from(0).to(1)

        fact_coach_action = Analytics::FactCoachAction.take(1).first

        expect(fact_coach_action.dim_person_executor).to eq(dim_person_executor)
        expect(fact_coach_action.dim_person_target).to eq(dim_person_target)
        expect(fact_coach_action.action_taken_at).to eq(message.occurred_at)
        expect(fact_coach_action.action).to eq(Analytics::FactCoachAction::Actions::SEEKER_CERTIFIED)
      end
    end
  end
end
