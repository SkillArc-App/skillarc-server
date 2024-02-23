require 'rails_helper'

RSpec.describe "Jobs", type: :request do
  describe "GET /jobs" do
    subject { get coaches_jobs_path, headers: }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls Coaches::JobService.all" do
        expect_any_instance_of(Coaches::JobService).to receive(:all).and_call_original

        subject
      end
    end
  end
end
