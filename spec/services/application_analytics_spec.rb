require 'rails_helper'

RSpec.describe ApplicationAnalytics do
  let!(:applicant1) { create(:applicant, applicant_statuses: [a1_status1, a1_status2], profile: profile1) }

  let(:profile1) { create(:profile, user: user1) }
  let(:user1) { create(:user, first_name: "Tom", last_name: "Hanks") }

  let(:a1_status1) { build(:applicant_status, status: ApplicantStatus::StatusTypes::NEW, created_at: Date.new(2020, 6, 1)) }
  let(:a1_status2) { build(:applicant_status, status: ApplicantStatus::StatusTypes::PENDING_INTRO, created_at: Date.new(2020, 6, 2)) }

  let!(:applicant2) { create(:applicant, applicant_statuses: [a2_status1], profile: profile2) }
  let(:a2_status1) { build(:applicant_status, status: ApplicantStatus::StatusTypes::NEW, created_at: Date.new(2020, 6, 15)) }

  let(:profile2) { create(:profile, user: user2) }
  let(:user2) { create(:user, first_name: "Tim", last_name: "Allen") }

  describe "#average_status_times" do
    it "returns the status times" do
      Timecop.freeze(Date.new(2020, 7, 1)) do
        expect(subject.average_status_times).to contain_exactly(
          {
            status: ApplicantStatus::StatusTypes::NEW,
            time: {
              days: 8,
              hours: 12
            }
          },
          {
            status: ApplicantStatus::StatusTypes::PENDING_INTRO,
            time: {
              days: 29,
              hours: 0
            }
          }
        )
      end
    end
  end

  describe "#current_status_times" do
    it "returns the status times" do
      Timecop.freeze(Date.new(2020, 7, 1)) do
        expect(subject.current_status_times).to contain_exactly(
          {
            id: applicant1.id,
            applicant_name: "Tom Hanks",
            employment_title: applicant1.job.employment_title,
            employer_name: applicant1.job.employer.name,
            status: ApplicantStatus::StatusTypes::PENDING_INTRO,
            time: {
              days: 29,
              hours: 0
            }
          },
          {
            id: applicant2.id,
            applicant_name: "Tim Allen",
            employment_title: applicant2.job.employment_title,
            employer_name: applicant2.job.employer.name,
            status: ApplicantStatus::StatusTypes::NEW,
            time: {
              days: 16,
              hours: 0
            }
          }
        )
      end
    end
  end

  describe "#persist_current_status_times" do
    it "persists the current status times" do
      Timecop.freeze(Date.new(2020, 7, 1)) do
        expect { subject.persist_current_status_times }.to change { ApplicantAnalytic.count }.by(2)

        expect(ApplicantAnalytic.all).to contain_exactly(
          have_attributes(
            applicant_id: applicant1.id,
            job_id: applicant1.job.id,
            employer_id: applicant1.job.employer.id,
            employer_name: applicant1.job.employer.name,
            employment_title: applicant1.job.employment_title,
            applicant_name: "Tom Hanks",
            applicant_email: user1.email,
            status: ApplicantStatus::StatusTypes::PENDING_INTRO,
            days: 29,
            hours: 0
          ),
          have_attributes(
            applicant_id: applicant2.id,
            job_id: applicant2.job.id,
            employer_id: applicant2.job.employer.id,
            employer_name: applicant2.job.employer.name,
            employment_title: applicant2.job.employment_title,
            applicant_name: "Tim Allen",
            applicant_email: user2.email,
            status: ApplicantStatus::StatusTypes::NEW,
            days: 16,
            hours: 0
          )
        )
      end
    end
  end
end