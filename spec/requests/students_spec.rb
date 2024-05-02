require 'rails_helper'

RSpec.describe "Students", type: :request do
  describe "GET /index" do
    subject { get students_path, headers: }

    it_behaves_like "training provider secured endpoint"

    context "when authenticated" do
      include_context "training provider authenticated"

      it "returns 200" do
        subject

        expect(response).to have_http_status(:ok)
      end

      context "when students and invitees" do
        before do
          program = create(:program, training_provider:)
          create(:seeker_training_provider, program:, training_provider:)
          stp = create(:seeker_training_provider, program:, training_provider:)

          create(:seeker_invite, training_provider:, program:)
        end

        it "returns 200" do
          subject

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
