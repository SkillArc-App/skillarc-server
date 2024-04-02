require 'rails_helper'

RSpec.describe "Coaches::Barriers", type: :request do
  describe "GET /index" do
    subject { get barriers_path, headers: }

    it_behaves_like 'coach secured endpoint'

    context "authenticated" do
      include_context "coach authenticated"

      it "calls BarrierService.all" do
        expect(Coaches::CoachesQuery).to receive(:all_barriers).and_call_original

        subject
      end
    end
  end
end
