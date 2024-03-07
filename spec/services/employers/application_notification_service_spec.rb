require 'rails_helper'

RSpec.describe Employers::ApplicationNotificationService do
  it_behaves_like "an event consumer"

  let(:job_owners) { create(:employers_job_owner, job:) }
  let(:recruiter) { job_owners.recruiter }
  let(:job) { create(:employers_job, category:, employment_title: "employment_title") }
  let(:job_id) { job.job_id }

  describe "application created" do
    subject { described_class.new.handle_message(applicant_status_updated) }

    let(:applicant_status_updated) { build(:message, :applicant_status_updated, version: 5, data:, metadata:) }
    let(:data) do
      Events::ApplicantStatusUpdated::Data::V4.new(
        applicant_id: applicant.applicant_id,
        applicant_first_name: applicant.first_name,
        applicant_last_name: applicant.last_name,
        applicant_email: applicant.email,
        applicant_phone_number: applicant.phone_number,
        profile_id: applicant.seeker_id,
        seeker_id: applicant.seeker_id,
        user_id: SecureRandom.uuid,
        job_id: applicant.job.job_id,
        employer_name: "employer_name",
        employment_title: "employment_title",
        status:
      )
    end
    let(:metadata) do
      Events::ApplicantStatusUpdated::MetaData::V1.new
    end
    let(:applicant) { create(:employers_applicant, job:) }
    let(:status) { ApplicantStatus::StatusTypes::NEW }

    let(:category) { Job::Categories::MARKETPLACE }

    context "when the seeker isn't certified" do
      context "when the job is in the staffing category" do
        let(:category) { Job::Categories::STAFFING }

        it "does not send an email to the employer" do
          expect(CommandService).not_to receive(:create!)

          subject
        end
      end

      context "when the job is in the marketplace category" do
        it "sends an email to the employer" do
          expect(CommandService)
            .to receive(:create!)
            .with(
              command_schema: Commands::NotifyEmployerOfApplicant::V1,
              applicant_id: data.applicant_id,
              trace_id: applicant_status_updated.trace_id,
              data: Commands::NotifyEmployerOfApplicant::Data::V1.new(
                employment_title: data.employment_title,
                recepent_email: recruiter.email,
                certified_by: nil,
                applicant_first_name: data.applicant_first_name,
                applicant_last_name: data.applicant_last_name,
                applicant_seeker_id: data.seeker_id,
                applicant_email: data.applicant_email,
                applicant_phone_number: data.applicant_phone_number
              )
            )
            .and_call_original

          subject
        end
      end
    end

    context "when the seeker is certified" do
      let!(:employers_seeker) { create(:employers_seeker, seeker_id: applicant.seeker_id) }

      context "when the job is in the staffing category" do
        it "sends an email to the employer" do
          expect(CommandService)
            .to receive(:create!)
            .with(
              command_schema: Commands::NotifyEmployerOfApplicant::V1,
              applicant_id: data.applicant_id,
              trace_id: applicant_status_updated.trace_id,
              data: Commands::NotifyEmployerOfApplicant::Data::V1.new(
                employment_title: data.employment_title,
                recepent_email: recruiter.email,
                certified_by: employers_seeker.certified_by,
                applicant_first_name: data.applicant_first_name,
                applicant_last_name: data.applicant_last_name,
                applicant_seeker_id: data.seeker_id,
                applicant_email: data.applicant_email,
                applicant_phone_number: data.applicant_phone_number
              )
            )
            .and_call_original

          subject
        end
      end

      context "when the job is in the marketplace category" do
        it "sends an email to the employer" do
          expect(CommandService)
            .to receive(:create!)
            .with(
              command_schema: Commands::NotifyEmployerOfApplicant::V1,
              applicant_id: data.applicant_id,
              trace_id: applicant_status_updated.trace_id,
              data: Commands::NotifyEmployerOfApplicant::Data::V1.new(
                employment_title: data.employment_title,
                recepent_email: recruiter.email,
                certified_by: employers_seeker.certified_by,
                applicant_first_name: data.applicant_first_name,
                applicant_last_name: data.applicant_last_name,
                applicant_seeker_id: data.seeker_id,
                applicant_email: data.applicant_email,
                applicant_phone_number: data.applicant_phone_number
              )
            )
            .and_call_original

          subject
        end
      end
    end
  end

  describe "seeker certified" do
    subject { described_class.new.handle_message(seeker_certified) }

    let(:seeker_certified) { build(:message, :seeker_certified, aggregate_id: seeker_id, version: 1, data:) }
    let(:seeker_id) { applicant.seeker_id }
    let(:data) do
      Events::SeekerCertified::Data::V1.new(
        coach_first_name: "Mr",
        coach_last_name: "Coach",
        coach_email: "coach@skillarc.com",
        coach_id: SecureRandom.uuid
      )
    end
    let(:applicant) { create(:employers_applicant, job:) }
    let(:job) { create(:employers_job, category:) }

    context "when the seeker is applying to a staffing job" do
      let(:category) { Job::Categories::STAFFING }

      it "sends an email to the employer" do
        expect(CommandService)
          .to receive(:create!)
          .with(
            command_schema: Commands::NotifyEmployerOfApplicant::V1,
            applicant_id: applicant.applicant_id,
            trace_id: seeker_certified.trace_id,
            data: Commands::NotifyEmployerOfApplicant::Data::V1.new(
              employment_title: job.employment_title,
              recepent_email: recruiter.email,
              certified_by: "coach@skillarc.com",
              applicant_first_name: applicant.first_name,
              applicant_last_name: applicant.last_name,
              applicant_seeker_id: applicant.seeker_id,
              applicant_email: applicant.email,
              applicant_phone_number: applicant.phone_number
            )
          )
          .and_call_original

        subject
      end
    end

    context "when the seeker is applying to a marketplace job" do
      let(:category) { Job::Categories::MARKETPLACE }

      it "does not send an email to the employer" do
        expect(CommandService).not_to receive(:create!)

        subject
      end
    end
  end
end
