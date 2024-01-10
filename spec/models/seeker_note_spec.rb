require 'rails_helper'

RSpec.describe SeekerNote do
  describe "#coach_seeker_context" do
    let(:seeker_note) { create(:seeker_note, coach_seeker_context:) }
    let(:coach_seeker_context) { create(:coach_seeker_context) }

    it "references the owning seeker context" do
      expect(seeker_note.coach_seeker_context).to eq(coach_seeker_context)
    end
  end

  describe "validations" do
    context "when note is missing" do
      it "does not validate" do
        expect(build(:seeker_note, note: nil)).not_to be_valid
      end
    end

    context "when note_id is missing" do
      it "does not validate" do
        expect(build(:seeker_note, note_id: nil)).not_to be_valid
      end
    end
  end
end
