require 'rails_helper'

RSpec.describe Coaches::SeekerLead do
  describe "validations" do
    context "when lead_id is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, lead_id: nil)).not_to be_valid
      end
    end

    context "when first_name is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, first_name: nil)).not_to be_valid
      end
    end

    context "when last_name is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, last_name: nil)).not_to be_valid
      end
    end

    context "when phone_number is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, phone_number: nil)).not_to be_valid
      end
    end

    context "when status is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, status: nil)).not_to be_valid
      end
    end

    context "when status not in the inclusion list" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, status: "invalid")).not_to be_valid
      end
    end

    context "when lead captured at is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, lead_captured_at: nil)).not_to be_valid
      end
    end

    context "when lead captured by is missing" do
      it "does not validate" do
        expect(build(:coaches__seeker_lead, lead_captured_by: nil)).not_to be_valid
      end
    end
  end
end
