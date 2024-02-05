require 'rails_helper'

RSpec.describe UserEvents do
  describe "#all" do
    subject { described_class.new(user).all }

    let(:user) { create(:user) }

    let!(:event) { create(:event, :user_created, occurred_at:, aggregate_id: user.id) }
    let!(:education_experience_created_event) do
      create(
        :event,
        :education_experience_created,
        occurred_at:,
        aggregate_id: user.id,
        data: Events::EducationExperienceCreated::Data::V1.new(
          organization_name: "Test University",
          id: SecureRandom.uuid,
          title: "A title",
          graduation_date: Time.zone.now.to_s,
          activities: nil,
          gpa: "1.8",
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid
        ).to_h
      )
    end
    let!(:work_experience) do
      create(
        :event,
        :experience_created,
        occurred_at:,
        aggregate_id: user.id,
        data: Events::ExperienceCreated::Data::V1.new(
          id: SecureRandom.uuid,
          organization_name: "Test Company",
          position: "Test Position",
          start_date: Time.zone.now.to_s,
          end_date: nil,
          description: "My job",
          is_current: false,
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid
        ).to_h
      )
    end
    let!(:onboarding_complete_event) do
      create(
        :event,
        :onboarding_completed,
        occurred_at:,
        aggregate_id: user.id
      )
    end
    let!(:job_saved_event) do
      create(
        :event,
        :job_saved,
        occurred_at:,
        aggregate_id: user.id,
        data: {
          employment_title: "Test Job"
        }
      )
    end

    let!(:applicant_status_updated_event) do
      create(
        :event,
        :applicant_status_updated,
        occurred_at:,
        aggregate_id: job.id,
        data: Events::ApplicantStatusUpdated::Data::V1.new(
          applicant_id: SecureRandom.uuid,
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid,
          job_id: SecureRandom.uuid,
          user_id: user.id,
          employment_title: "Test Job",
          employer_name: "Test Employer",
          status: "new"
        ).to_h
      )
    end

    let(:occurred_at) { Time.utc(2023, 12, 1) }

    let(:job) { create(:job) }

    it "returns the events" do
      expect(subject).to contain_exactly(
        { datetime: '2023-11-30  7:00PM', event_message: "Signed Up" },
        { datetime: '2023-11-30  7:00PM', event_message: "Education Experience Created: Test University" },
        { datetime: '2023-11-30  7:00PM', event_message: "Work Experience Created: Test Company" },
        { datetime: '2023-11-30  7:00PM', event_message: "Onboarding Complete" },
        { datetime: '2023-11-30  7:00PM', event_message: "Job Saved: Test Job" },
        { datetime: '2023-11-30  7:00PM', event_message: "Applicant Status Updated: Test Job - new" }
      )
    end
  end
end
