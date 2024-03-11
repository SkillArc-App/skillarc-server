require 'rails_helper'

RSpec.describe Employers::WeeklyUpdateService do
  it_behaves_like "an event consumer"

  describe "day elapsed" do
    subject { described_class.new(command_service: CommandService.new).handle_message(message) }

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

        expect_any_instance_of(CommandService)
          .to receive(:create!)
          .with(
            command_schema: Commands::SendWeeklyEmployerUpdate::V1,
            employer_id: employer.id,
            trace_id: be_a(String),
            data: Commands::SendWeeklyEmployerUpdate::Data::V1.new(
              employer_name: employer.name,
              recepent_email: recruiter.email,
              new_applicants:,
              pending_applicants:
            )
          ).and_call_original

        expect_any_instance_of(CommandService)
          .to receive(:create!)
          .with(
            command_schema: Commands::SendWeeklyEmployerUpdate::V1,
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
        expect_any_instance_of(CommandService).not_to receive(:create!)

        subject
      end
    end
  end
end
