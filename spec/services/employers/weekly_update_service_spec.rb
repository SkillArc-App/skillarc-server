require 'rails_helper'

RSpec.describe Employers::WeeklyUpdateService do
  it_behaves_like "an event consumer"

  describe "day elapsed" do
    subject { described_class.new.handle_event(message) }

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
    let!(:recruiter) { create(:employers_recruiter, employer:) }
    let!(:second_recruiter) { create(:employers_recruiter, employer:) }

    let(:dead_employer) { create(:employers_employer) }
    let(:dead_job) { create(:employers_job, employer: dead_employer, hide_job: true) }
    let!(:dead_applicant) { create(:employers_applicant, job: dead_job, status_as_of: date - 1.day) }
    let(:dead_recruiter) { create(:employers_recruiter, employer: dead_employer) }

    context "when the day is a Tuesday" do
      let(:date) { Date.new(2024, 2, 20) }

      it "enqueues a job" do
        expect(Employers::DeliverWeeklySummaryJob).to receive(:perform_later).with(
          new_applicants: [{ first_name: new_applicant.first_name, last_name: new_applicant.last_name }],
          pending_applicants: [{ first_name: pending_applicant.first_name, last_name: pending_applicant.last_name }],
          employer: { name: employer.name },
          recruiter: { email: recruiter.email }
        ).and_call_original

        expect(Employers::DeliverWeeklySummaryJob).to receive(:perform_later).with(
          new_applicants: [{ first_name: new_applicant.first_name, last_name: new_applicant.last_name }],
          pending_applicants: [{ first_name: pending_applicant.first_name, last_name: pending_applicant.last_name }],
          employer: { name: employer.name },
          recruiter: { email: second_recruiter.email }
        ).and_call_original

        subject
      end
    end

    context "when the day is not a Tuesday" do
      let(:date) { Date.new(2024, 2, 21) }

      it "does not call SmtpService#send_weekly_employer_update" do
        expect_any_instance_of(Contact::SmtpService).not_to receive(:send_weekly_employer_update)
        expect(Employers::DeliverWeeklySummaryJob).not_to receive(:perform_later)

        subject
      end
    end
  end
end
