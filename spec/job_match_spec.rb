require "rails_helper"

# test the JobMatch class
RSpec.describe JobMatch do
  # subject { described_class.new(profile: profile, job: job) }

  let(:job) { Match::Job.new(industry: "manufacturing") }

  context "when the profile's industry interest includes the job's industry" do
    let(:profile) { Match::Profile.new(industry_interests: ["manufacturing"]) }

    xit "returns a match score of 1" do
      expect(described_class.new(profile:, job:).match_score).to eq(1)
    end
  end

  context "when the profile's industry interest does not include the job's industry" do
    let(:profile) { Match::Profile.new(industry_interests: ["retail"]) }

    xit "returns a match score of 0" do
      expect(described_class.new(profile:, job:).match_score).to eq(0)
    end
  end
end
