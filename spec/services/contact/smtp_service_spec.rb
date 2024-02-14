require 'rails_helper'

RSpec.describe Contact::SmtpService do
  describe "#notify_employer_of_applicant" do
    subject { described_class.new.notify_employer_of_applicant(job, applicant) }

    let(:job) do
      double(
        employment_title: "Job Title",
        owner_email: "recruiter@skillarc.com"
      )
    end
    let(:applicant) do
      double(
        first_name: "John",
        last_name: "Chabot",
        email: "applicant@a.com",
        phone_number: "1 555 555 5555",
        seeker_id: "seeker_id"
      )
    end

    it "sends an email" do
      expect(EmployerApplicantNotificationMailer)
        .to receive(:notify_employer)
        .with(job, applicant)
        .and_call_original

      expect_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).and_call_original

      subject
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SmtpSent::V1,
        aggregate_id: "applicant@a.com",
        data: Events::SmtpSent::Data::V1.new(
          email: "recruiter@skillarc.com",
          template: EmployerApplicantNotificationMailer.class.to_s,
          template_data: {
            job: {
              employment_title: "Job Title",
              owner_email: "recruiter@skillarc.com"
            },
            applicant: {
              first_name: "John",
              last_name: "Chabot",
              email: "applicant@a.com",
              phone_number: "1 555 555 5555",
              seeker_id: "seeker_id"
            }
          }
        )
      )

      subject
    end
  end
end
