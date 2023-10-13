require "rails_helper"

RSpec.describe JobMatch::JobMatch do
  subject { described_class.new(profile_id: "047aebd1-f3af-41d0-b96f-1af8e7344ba8") }

  it "initalizes with a profile" do
    expect(subject.profile).not_to be_nil
    expect(subject.profile[:industry_interests]).not_to be_nil
  end

  it "initializes with a list of jobs" do
    expect(subject.jobs).not_to be_nil
  end

  it "returns a list of jobs with a percent match" do
    expect(subject.jobs.first[:percent_match]).to eq(0)
  end
end
