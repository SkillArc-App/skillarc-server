require 'rails_helper'

RSpec.describe Employers::ApplicantService do
  describe "#all" do
    subject { described_class.new(employers: [employer]).all }

    let(:employer) do
      create(
        :employers_employer,
        name: "Employer"
      )
    end
    let!(:applicant) do
      create(
        :employers_applicant,
        job:,
        email: "hannah.block@skillarc.com",
        first_name: "Hannah",
        last_name: "Block",
        phone_number: "123-456-7890",
        status: Employers::Applicant::StatusTypes::NEW,
        status_as_of: Time.zone.now
      )
    end
    let(:job) do
      create(
        :employers_job,
        employer:,
        employment_title: "Welder"
      )
    end

    it "returns all applicants for the employer" do
      expect(subject).to eq(
        [
          {
            id: applicant.id,
            job_id: job.id,
            chat_enabled: true,
            created_at: applicant.created_at,
            job_name: "Welder",
            first_name: "Hannah",
            last_name: "Block",
            phone_number: "123-456-7890",
            profile_link: "/profiles/#{applicant.seeker_id}",
            programs: [], # TODO
            status_reasons: [], # TODO
            status: Employers::Applicant::StatusTypes::NEW,
            email: "hannah.block@skillarc.com"
          }
        ]
      )
    end
  end
end
