require 'rails_helper'

RSpec.describe Employers::Employer do
  describe ".applicants" do
    let(:employer) { create(:employers_employer) }

    let(:job1) { create(:employers_job, employer:) }
    let(:job2) { create(:employers_job, employer:) }

    let!(:applicant1) { create(:employers_applicant, job: job1) }
    let!(:applicant2) { create(:employers_applicant, job: job2) }
    let!(:applicant3) { create(:employers_applicant) }

    it "returns all applicants for the employer" do
      expect(employer.applicants).to match_array([applicant1, applicant2])
    end
  end
end
