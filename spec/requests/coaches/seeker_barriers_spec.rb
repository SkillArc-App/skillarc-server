require 'rails_helper'

RSpec.describe "Coaches::SeekerBarriersController", type: :request do
  describe "PUT /update_barriers" do
    subject { put seeker_update_barriers_path(seeker_id), params:, headers: }

    let(:seeker_id) { coach_seeker_context.seeker_id }
    let(:params) do
      {
        barriers: [
          create(:barrier).barrier_id
        ]
      }
    end
    let(:coach_seeker_context) { create(:coaches__coach_seeker_context) }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.update_barriers" do
        expect_any_instance_of(Coaches::SeekerService)
          .to receive(:update_barriers)
          .with(
            seeker_id:,
            barriers: params[:barriers]
          )
          .and_call_original

        subject
      end
    end
  end
end
