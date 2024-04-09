require 'rails_helper'

RSpec.describe Employers::EmployerReactor do
  it_behaves_like "a message consumer"

  describe "#handle_message" do
    subject { described_class.new(message_service: MessageService.new).handle_message(message) }

    describe "when message is application status updated" do
      let(:message) { build(:message, schema: Events::ApplicantStatusUpdated::V5, data:, metadata:) }
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

      let(:job_owners) { create(:employers_job_owner) }
      let(:recruiter) { job_owners.recruiter }
      let(:job) { job_owners.job }
      let(:job_id) { job.job_id }

      context "when the seeker isn't certified" do
        it "sends an email to the employer" do
          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Commands::NotifyEmployerOfApplicant::V1,
              applicant_id: data.applicant_id,
              trace_id: message.trace_id,
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

      context "when the seeker is certified" do
        let!(:employers_seeker) { create(:employers_seeker, seeker_id: applicant.seeker_id) }

        it "sends an email to the employer" do
          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Commands::NotifyEmployerOfApplicant::V1,
              applicant_id: data.applicant_id,
              trace_id: message.trace_id,
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

    describe "when message is day elapsed" do
      let(:message) do
        build(
          :message,
          :day_elapsed,
          data: Events::DayElapsed::Data::V1.new(
            date:,
            day_of_week:
          )
        )
      end
      let(:day_of_week) { date.strftime("%A").downcase }

      let(:employer) { create(:employers_employer) }
      let(:job) { create(:employers_job, employer:) }

      let!(:new_applicant) { create(:employers_applicant, job:, status_as_of: date - 1.day) }
      let!(:pending_applicant) { create(:employers_applicant, job:, status_as_of: date - 2.weeks) }
      let!(:seeker) { create(:employers_seeker, certified_by: "jim@skillarc.com", seeker_id: new_applicant.seeker_id) }
      let!(:recruiter) { create(:employers_recruiter, employer:) }
      let!(:second_recruiter) { create(:employers_recruiter, employer:) }

      let(:dead_employer) { create(:employers_employer) }
      let(:dead_job) { create(:employers_job, employer: dead_employer, hide_job: true) }
      let!(:dead_applicant) { create(:employers_applicant, job: dead_job, status_as_of: date - 1.day) }
      let(:dead_recruiter) { create(:employers_recruiter, employer: dead_employer) }

      context "when the day is a Tuesday" do
        let(:date) { Date.new(2024, 2, 20) }

        it "enqueues a job" do
          new_applicants = [
            Commands::SendWeeklyEmployerUpdate::SummaryApplicant::V1.new(
              first_name: new_applicant.first_name,
              last_name: new_applicant.last_name,
              certified_by: seeker.certified_by
            )
          ]

          pending_applicants = [
            Commands::SendWeeklyEmployerUpdate::SummaryApplicant::V1.new(
              first_name: pending_applicant.first_name,
              last_name: pending_applicant.last_name,
              certified_by: nil
            )
          ]

          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Commands::SendWeeklyEmployerUpdate::V1,
              employer_id: employer.id,
              trace_id: be_a(String),
              data: Commands::SendWeeklyEmployerUpdate::Data::V1.new(
                employer_name: employer.name,
                recepent_email: recruiter.email,
                new_applicants:,
                pending_applicants:
              )
            ).and_call_original

          expect_any_instance_of(MessageService)
            .to receive(:create!)
            .with(
              schema: Commands::SendWeeklyEmployerUpdate::V1,
              employer_id: employer.id,
              trace_id: be_a(String),
              data: Commands::SendWeeklyEmployerUpdate::Data::V1.new(
                employer_name: employer.name,
                recepent_email: second_recruiter.email,
                new_applicants:,
                pending_applicants:
              )
            ).and_call_original

          subject
        end
      end

      context "when the day is not a Tuesday" do
        let(:date) { Date.new(2024, 2, 21) }

        it "does not call SmtpService#send_weekly_employer_update" do
          expect_any_instance_of(MessageService).not_to receive(:create!)

          subject
        end
      end
    end
  end
end
