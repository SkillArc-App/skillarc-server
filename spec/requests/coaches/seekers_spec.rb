require 'rails_helper'

RSpec.describe "Seekers", type: :request do
  describe "GET /index" do
    subject { get seekers_path, headers: }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.all" do
        expect(Coaches::SeekerService).to receive(:all)

        subject
      end
    end
  end

  describe "GET /show" do
    subject { get seeker_path(seeker_id), headers: }

    let(:seeker_id) { create(:coaches__coach_seeker_context).profile_id }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.find" do
        expect(Coaches::SeekerService).to receive(:find).with(seeker_id)

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

      it "calls SeekerService.update_skill_level" do
        expect(Coaches::SeekerService).to receive(:update_skill_level).with(seeker_id, params[:level])

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
    let(:coach) { create(:coaches__coach) }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.assign_coach" do
        expect(Coaches::SeekerService).to receive(:assign_coach).with(seeker_id, params[:coach_id], coach.email)

        subject
      end
    end
  end
end
