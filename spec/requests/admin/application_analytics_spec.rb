require 'rails_helper'

RSpec.describe "ApplicationAnalytics", type: :request do
  describe "GET /index" do
    subject { get admin_application_analytics_path, headers: }

    it_behaves_like "admin secured endpoint"

    context "when the user is an admin" do
      include_context "admin authenticated"

      it "calls the ApplicationAnalytics service" do
        expect_any_instance_of(ApplicationAnalytics).to receive(:average_status_times).and_return(
          [
            {
              status: ApplicantStatus::StatusTypes::NEW,
              time: {
                days: 1,
                hours: 2
              }
            }
          ]
        )

        expect_any_instance_of(ApplicationAnalytics).to receive(:current_status_times).and_return(
          [
            {
              id: 1,
              applicant_name: "John Doe",
              employment_title: "Laborer",
              employer_name: "Blocktrain",
              status: ApplicantStatus::StatusTypes::NEW,
              time: {
                days: 1,
                hours: 2
              }
            }
          ]
        )

        subject

        expect(response).to have_http_status(:ok)

        json_response = response.parsed_body

        expect(json_response["averageStatusTimes"]).to eq(
          [
            {
              "status" => ApplicantStatus::StatusTypes::NEW,
              "time" => {
                "days" => 1,
                "hours" => 2
              }
            }
          ]
        )

        expect(json_response["currentStatusTimes"]).to eq(
          [
            {
              "id" => 1,
              "applicant_name" => "John Doe",
              "employment_title" => "Laborer",
              "employer_name" => "Blocktrain",
              "status" => ApplicantStatus::StatusTypes::NEW,
              "time" => {
                "days" => 1,
                "hours" => 2
              }
            }
          ]
        )
      end
    end
  end
end
