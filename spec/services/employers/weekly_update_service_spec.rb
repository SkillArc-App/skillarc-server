require 'rails_helper'

RSpec.describe Employers::WeeklyUpdateService do
  it_behaves_like "an event consumer"

  describe "day elapsed" do
    subject { described_class.handle_event(message) }

    let(:message) do
      build(
        :events__message,
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

    context "when the day is a Tuesday" do
      let(:date) { Date.new(2024, 2, 20) }

      it "calls SmtpService#send_weekly_employer_update" do
        expect_any_instance_of(Contact::SmtpService).to receive(:send_weekly_employer_update).with(
          new_applicants: [new_applicant],
          pending_applicants: [pending_applicant],
          employer:,
          recruiter:
        )

        subject
      end
    end

    context "when the day is not a Tuesday" do
      let(:date) { Date.new(2024, 2, 21) }

      it "does not call SmtpService#send_weekly_employer_update" do
        expect_any_instance_of(Contact::SmtpService).not_to receive(:send_weekly_employer_update)

        subject
      end
    end
  end
end
