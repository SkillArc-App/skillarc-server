require 'rails_helper'

RSpec.describe Employers::Applicant do
  describe ".active" do
    subject { described_class.active }

    let!(:pass) { create(:employers_applicant, status: described_class::StatusTypes::PASS, job: marketplace_job) }
    let!(:hire) { create(:employers_applicant, status: described_class::StatusTypes::HIRE, job: marketplace_job) }
    let!(:interviewing) { create(:employers_applicant, status: described_class::StatusTypes::INTERVIEWING, job: marketplace_job) }
    let!(:intro_made) { create(:employers_applicant, status: described_class::StatusTypes::INTRO_MADE, job: marketplace_job) }
    let!(:pending_intro) { create(:employers_applicant, status: described_class::StatusTypes::PENDING_INTRO, job: marketplace_job) }
    let!(:new_app) { create(:employers_applicant, status: described_class::StatusTypes::NEW, job: marketplace_job) }

    let!(:new_app_staffing) { create(:employers_applicant, :uncertified, status: described_class::StatusTypes::NEW, job: staffing_job) }
    let!(:new_app_staffing_certified) { create(:employers_applicant, status: described_class::StatusTypes::NEW, job: staffing_job) }

    let(:marketplace_job) { create(:employers_job, category: Employers::Job::Categories::MARKETPLACE) }
    let(:staffing_job) { create(:employers_job, category: Employers::Job::Categories::STAFFING) }

    it "returns applicants non-terminal applicants" do
      expect(subject).to match_array([new_app, pending_intro, intro_made, interviewing, new_app_staffing_certified])
    end
  end
end
