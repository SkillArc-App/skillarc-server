require 'rails_helper'

RSpec.describe "UserEvents", type: :request do
  describe "GET /show" do
    subject { get user_event_path(user), headers: headers }

    let(:user) { create(:user) }

    it_behaves_like "admin secured endpoint"

    context "when the user is an admin" do
      include_context "admin authenticated"

      it "calls the UserEvents service" do
        expect(UserEvents).to receive(:new).and_call_original
        expect_any_instance_of(UserEvents).to receive(:all)

        subject
      end
    end
  end
end
