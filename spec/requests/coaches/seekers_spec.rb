require 'rails_helper'

RSpec.describe "Seekers", type: :request do
  describe "GET /index" do
    subject { get seekers_path, headers: }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachSeekers.all" do
        expect(CoachSeekers).to receive(:all)

        subject
      end
    end
  end

  describe "GET /show" do
    subject { get seeker_path(seeker_id), headers: }

    let(:seeker_id) { create(:coach_seeker_context).profile_id }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachSeekers.find" do
        expect(CoachSeekers).to receive(:find).with(seeker_id)

        subject
      end
    end
  end

  describe "POST /:seeker_id/notes" do
    subject { post seeker_notes_path(seeker_id), params:, headers: }

    let(:seeker_id) { create(:profile).id }
    let(:params) do
      {
        note: "This is a note"
      }
    end

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachSeekers.create_note" do
        expect(CoachSeekers).to receive(:add_note).with(seeker_id, params[:note])

        subject
      end
    end
  end

  describe "POST /:seeker_id/skill-levels" do
    subject { post seeker_skill_levels_path(seeker_id), params:, headers: }

    let(:seeker_id) { create(:profile).id }
    let(:params) do
      {
        level: "advanced"
      }
    end

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachSeekers.update_skill_level" do
        expect(CoachSeekers).to receive(:update_skill_level).with(seeker_id, params[:level])

        subject
      end
    end
  end

  describe "POST /:seeker_id/assign_coach" do
    subject { post seeker_assign_coach_path(seeker_id), params:, headers: }

    let(:seeker_id) { "123" }
    let(:params) do
      {
        coach_id: coach.id
      }
    end
    let(:coach) { create(:coach) }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachSeekers.assign_coach" do
        expect(CoachSeekers).to receive(:assign_coach).with(seeker_id, params[:coach_id], coach.email)

        subject
      end
    end
  end
end
