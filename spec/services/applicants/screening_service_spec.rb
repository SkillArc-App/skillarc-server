require 'rails_helper'

RSpec.describe Applicants::ScreeningService do
  describe "#screen" do
    subject { described_class.new(applicant).screen }

    let(:applicant) { create(:applicant, job:, certified_by:) }
    let(:job) { create(:job, category:) }
    let(:certified_by) { nil }

    context "for a marketplace job" do
      let(:category) { Job::Categories::MARKETPLACE }

      it "returns APPROVED" do
        expect(subject).to eq(described_class::ScreeningResults::APPROVED)
      end
    end

    context "for a staffing job" do
      let(:category) { Job::Categories::STAFFING }

      context "when the applicant is certified" do
        let(:certified_by) { "someone" }

        it "returns APPROVED" do
          expect(subject).to eq(described_class::ScreeningResults::APPROVED)
        end
      end

      context "when the applicant is not certified" do
        let(:certified_by) { nil }

        it "returns NOT_APPROVED" do
          expect(subject).to eq(described_class::ScreeningResults::NOT_APPROVED)
        end
      end
    end
  end
end
