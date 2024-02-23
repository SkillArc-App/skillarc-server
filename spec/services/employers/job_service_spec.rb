require 'rails_helper'

RSpec.describe Employers::JobService do
  describe ".all" do
    subject { described_class.new(employers: [employer]).all }

    let(:employer) do
      create(
        :employers_employer,
        name: "Employer"
      )
    end
    let!(:job) do
      create(
        :employers_job,
        employer:,
        employment_title: "Welder"
      )
    end

    it "returns all jobs for the employer" do
      expect(subject).to eq(
        [{
          id: job.id,
          description: "descriptions don't exist yet",
          employer_id: employer.employer_id,
          name: "Welder",
          employer_name: "Employer"
        }]
      )
    end
  end
end
