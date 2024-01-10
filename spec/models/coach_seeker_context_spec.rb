require 'rails_helper'

RSpec.describe CoachSeekerContext do
  describe "#seeker_notes" do
    let(:seeker_note1) { create(:seeker_note, coach_seeker_context:) }
    let(:seeker_note2) { create(:seeker_note, coach_seeker_context:) }
    let(:seeker_note3) { create(:seeker_note) }
    let(:coach_seeker_context) { create(:coach_seeker_context) }

    it "returns the seeker notes associated with this context" do
      expect(coach_seeker_context.seeker_notes).to contain_exactly(seeker_note1, seeker_note2)
    end
  end
end
