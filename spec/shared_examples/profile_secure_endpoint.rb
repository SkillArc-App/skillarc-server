RSpec.shared_context "profile owner" do
  include_context "authenticated"

  let(:profile) { create(:profile, user:) }
end

RSpec.shared_examples "a profile secured endpoint" do
  context "unauthenticated" do
    it "returns 401" do
      subject

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "authenticated" do
    context "user is a coach" do
      include_context "coach authenticated"

      it "returns 200" do
        subject

        expect(response).to have_http_status(:ok)
      end
    end

    context "user is not a coach" do
      include_context "authenticated"

      context "user is the profile owner" do
        include_context "profile owner"

        it "returns 200" do
          subject

          expect(response).to have_http_status(:ok)
        end
      end

      context "user is not the profile owner" do
        let(:profile) { create(:profile) }

        it "returns 401" do
          subject

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
