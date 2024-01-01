require 'rails_helper'

RSpec.describe "Coaches", type: :request do
  describe "GET /index" do
    subject { get coaches_path, headers: headers }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachesService.all" do
        expect(CoachesService).to receive(:all)

        subject
      end
    end
  end
end