require 'rails_helper'

RSpec.describe ProfileCompleteness do
  subject { described_class.new(profile) }

  let(:profile) { create(:profile) }

  describe "#status" do
    context "when the profile doesn't have work experience" do
      it "includes MISSING_WORK_EXPERIENCE" do
        expect(subject.status.result).to eq("incomplete")
        expect(subject.status.missing).to include("work")
      end
    end

    context "when the profile has work experience" do
      before do
        create(:other_experience, profile:)
      end
      
      it "doesn't include MISSING_WORK_EXPERIENCE" do
        expect(subject.status.missing).not_to include("work")
      end

      context "when the profile doesn't have education" do
        it "includes MISSING_EDUCATION" do
          expect(subject.status.result).to eq("incomplete")
          expect(subject.status.missing).to include("education")
        end
      end

      context "when the profile has education" do
        before do
          create(:education_experience, profile:)
        end

        it "doesn't include MISSING_EDUCATION" do
          expect(subject.status.result).to eq("complete")
          expect(subject.status.missing).to be_empty
        end
      end
    end
  end
end