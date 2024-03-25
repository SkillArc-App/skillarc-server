require 'rails_helper'

RSpec.describe Coaches::FeedAggregator do
  it_behaves_like "a message consumer"

  describe "applicant status updated" do
    subject { described_class.new.handle_message(applicant_status_updated) }

    let(:applicant_status_updated) { build(:message, :applicant_status_updated, version: 5, aggregate_id: job_id, data: status_updated1, metadata: status_metadata) }
    let(:job_id) { SecureRandom.uuid }
    let(:applicant_id) { SecureRandom.uuid }
    let(:status_updated1) do
      Events::ApplicantStatusUpdated::Data::V4.new(
        job_id:,
        applicant_id:,
        applicant_first_name: "Hannah",
        applicant_last_name: "Block",
        applicant_email: "hannah@hannah.com",
        applicant_phone_number: "1234567890",
        employer_name: "Employer",
        seeker_id:,
        user_id:,
        employment_title: "Software Engineer",
        status: ApplicantStatus::StatusTypes::NEW
      )
    end
    let(:seeker_id) { SecureRandom.uuid }
    let(:status_metadata) do
      Events::ApplicantStatusUpdated::MetaData::V1.new
    end
    let!(:coach_seeker_context) { create(:coaches__coach_seeker_context, user_id:) }
    let(:user_id) { SecureRandom.uuid }

    it "creates a new feed event" do
      expect { subject }.to change { Coaches::FeedEvent.count }.by(1)

      expect(Coaches::FeedEvent.last_created).to have_attributes(
        description: "Hannah Block's application for Software Engineer at Employer has been updated to new.",
        seeker_email: "hannah@hannah.com"
      )
    end
  end
end
