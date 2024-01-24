require 'rails_helper'

RSpec.describe "Leads", type: :request do
  describe "GET /leads" do
    subject { get leads_path, headers: }

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      before do
        create(:coaches__seeker_lead)
      end

      include_context "coach authenticated"

      it "calls CoachService.all" do
        expect(Coaches::SeekerService).to receive(:all_leads).and_call_original

        subject
      end
    end
  end

  describe "POST /leads" do
    subject { post leads_path, headers:, params: }

    let(:params) do
      {
        lead: {
          email: "john.chabot@blocktrainapp.com",
          phone_number: "333-333-3333",
          first_name: "john",
          last_name: "Chabot"
        }
      }
    end

    it_behaves_like "coach secured endpoint"

    context "authenticated" do
      include_context "coach authenticated"

      it "calls CoachService.all" do
        expect(Coaches::SeekerService)
          .to receive(:add_lead)
          .with(
            coach:,
            email: "john.chabot@blocktrainapp.com",
            phone_number: "333-333-3333",
            first_name: "john",
            last_name: "Chabot"
          )
          .and_call_original

        subject
      end
    end
  end
end
