require 'rails_helper'

RSpec.describe Employers::DeliverWeeklySummaryJob do
  let(:new_applicant) { { first_name: "John", last_name: "Doe" } }
  let(:pending_applicant) { { first_name: "Jane", last_name: "Doe" } }
  let(:employer) { { name: "Acme" } }
  let(:recruiter) { { email: "foo@bar.baz" } }

  it "delivers a weekly summary" do
    expect_any_instance_of(Contact::SmtpService).to receive(:send_weekly_employer_update).with(
      new_applicants: [new_applicant],
      pending_applicants: [pending_applicant],
      employer:,
      recruiter:
    ).and_call_original

    described_class.perform_now(
      new_applicants: [new_applicant],
      pending_applicants: [pending_applicant],
      employer:,
      recruiter:
    )
  end
end
