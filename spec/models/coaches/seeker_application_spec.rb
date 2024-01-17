require 'rails_helper'

RSpec.describe Coaches::SeekerApplication do
  describe "#coach_seeker_context" do
    let(:seeker_application) { create(:coaches__seeker_application, coach_seeker_context:) }
    let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

    it "references the owning seeker context" do
      expect(seeker_application.coach_seeker_context).to eq(coach_seeker_context)
    end
  end

  describe "validations" do
    context "when status is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_application, status: nil)).not_to be_valid
      end
    end

    context "when employment_title is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_application, employment_title: nil)).not_to be_valid
      end
    end

    context "when application_id is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_application, application_id: nil)).not_to be_valid
      end
    end

    context "when job_id is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_application, job_id: nil)).not_to be_valid
      end
    end

    context "when employer_name is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_application, employer_name: nil)).not_to be_valid
      end
    end
  end
end
