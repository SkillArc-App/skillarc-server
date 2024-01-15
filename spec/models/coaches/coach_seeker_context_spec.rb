require 'rails_helper'

RSpec.describe Coaches::CoachSeekerContext do
  describe "#seeker_notes" do
    let(:seeker_note1) { create(:coaches__seeker_note, coach_seeker_context:) }
    let(:seeker_note2) { create(:coaches__seeker_note, coach_seeker_context:) }
    let(:seeker_note3) { create(:coaches__seeker_note) }
    let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

    it "returns the seeker notes associated with this context" do
      expect(coach_seeker_context.seeker_notes).to contain_exactly(seeker_note1, seeker_note2)
    end
  end
end
