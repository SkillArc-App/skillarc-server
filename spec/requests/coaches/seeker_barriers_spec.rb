require 'rails_helper'

RSpec.describe "Coaches::SeekerBarriers", type: :request do
  describe "PUT /update_barriers" do
    subject { put seeker_update_barriers_path(seeker_id), params:, headers: }

    let(:seeker_id) { SecureRandom.uuid }
    let(:params) do
      {
        barriers: [
          create(:barrier).id
        ]
      }
    end

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls SeekerService.update_barriers" do
        expect(Coaches::SeekerService)
          .to receive(:update_barriers)
          .with(
            id: seeker_id,
            barriers: params[:barriers]
          )
          .and_call_original

        subject
      end
    end
  end
end
