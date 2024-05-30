require 'rails_helper'

RSpec.describe UserEvents do
  describe "#all" do
    subject { described_class.new(user).all }

    let(:user) { create(:user, person_id: seeker.id) }
    let(:seeker) { create(:seeker) }

    let!(:event) { create(:event, schema: Events::UserCreated::V1, occurred_at:, aggregate_id: user.id) }
    let!(:education_experience_created_event) do
      create(
        :event,
        schema: Events::EducationExperienceAdded::V2,
        occurred_at:,
        aggregate_id: seeker.id,
        data: {
          organization_name: "Test University",
          id: SecureRandom.uuid,
          title: "A title",
          graduation_date: Time.zone.now.to_s,
          activities: nil,
          gpa: "1.8",
          seeker_id: seeker.id
        }
      )
    end
    let!(:work_experience) do
      create(
        :event,
        schema: Events::ExperienceAdded::V2,
        occurred_at:,
        aggregate_id: seeker.id,
        data: {
          id: SecureRandom.uuid,
          organization_name: "Test Company",
          position: "Test Position",
          start_date: "2000-12-10",
          end_date: nil,
          description: "My job",
          is_current: false
        }
      )
    end
    let!(:onboarding_complete_event) do
      create(
        :event,
        schema: Events::OnboardingCompleted::V3,
        occurred_at:,
        aggregate_id: seeker.id,
        data: {
          name: {},
          experience: nil,
          education: nil,
          trainingProvider: nil,
          other: nil,
          opportunityInterests: nil
        }
      )
    end
    let!(:job_saved_event) do
      create(
        :event,
        schema: Events::JobSaved::V1,
        occurred_at:,
        aggregate_id: user.id,
        data: {
          employment_title: "Test Job",
          job_id: SecureRandom.uuid,
          employer_name: "A"
        }
      )
    end

    let!(:applicant_status_updated_event) do
      create(
        :event,
        schema: Events::ApplicantStatusUpdated::V6,
        occurred_at:,
        aggregate_id: job.id,
        data: {
          applicant_id: SecureRandom.uuid,
          applicant_first_name: "John",
          applicant_last_name: "Chabot",
          applicant_email: "john@skillarc.com",
          profile_id: SecureRandom.uuid,
          seeker_id: SecureRandom.uuid,
          job_id: SecureRandom.uuid,
          user_id: user.id,
          employment_title: "Test Job",
          employer_name: "Test Employer",
          status: "new",
          reasons: []
        }
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
