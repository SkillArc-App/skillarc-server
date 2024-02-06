require "rails_helper"

RSpec.describe Jobs::JobBlueprint do
  describe "#render" do
    subject do
      described_class.render(job, view:, **options)
    end

    let(:job) { create(:job, career_paths: [career_path]) }
    let(:career_path) { build(:career_path, order: 0, lower_limit: 36_000, upper_limit: 42_000) }
    let(:industry) { ["cowboys"] }
    let(:tag) { create(:tag) }
    let!(:job_tag) { create(:job_tag, job:, tag:) }
    let(:options) { {} }

    context "default view" do
      let(:view) { :default }

      it "renders the id only" do
        expect(JSON.parse(subject)).to eq({ "id" => job.id })
      end
    end

    context "seeker view" do
      let(:view) { :seeker }

      context "when a seeker is not provided" do
        let(:options) { {} }

        it "assumes no applications or saved jobs" do
          expect(JSON.parse(subject)).to eq(
            {
              "id" => job.id,
              "employment_title" => job.employment_title,
              "employer" => {
                "id" => job.employer.id,
                "name" => job.employer.name,
                "logo_url" => job.employer.logo_url
              },
              "starting_pay" => {
                "employment_type" => "salary",
                "upper_limit" => career_path.upper_limit.to_i,
                "lower_limit" => career_path.lower_limit.to_i
              },
              "tags" => [tag.name],
              "location" => job.location,
              "industries" => job.industry,
              "saved" => false,
              "application_status" => nil
            }
          )
        end
      end

      context "when a user is provided" do
        let(:options) { { user: } }
        let(:user) { create(:user) }

        context "when the user hasn't do anything with the job" do
          it "shows it as unsaved with no application" do
            expect(JSON.parse(subject)).to eq(
              {
                "id" => job.id,
                "employment_title" => job.employment_title,
                "employer" => {
                  "id" => job.employer.id,
                  "name" => job.employer.name,
                  "logo_url" => job.employer.logo_url
                },
                "starting_pay" => {
                  "employment_type" => "salary",
                  "upper_limit" => career_path.upper_limit.to_i,
                  "lower_limit" => career_path.lower_limit.to_i
                },
                "tags" => [tag.name],
                "location" => job.location,
                "industries" => job.industry,
                "saved" => false,
                "application_status" => nil
              }
            )
          end
        end

        context "when the user has saved and applied to the job" do
          before do
            create(:event, aggregate_id: user.id, event_type: Event::EventTypes::JOB_SAVED, data: { job_id: job.id })
            seeker = create(:seeker, user:)
            create(:applicant, seeker:, job:)
          end

          it "shows it as save with application status" do
            expect(JSON.parse(subject)).to eq(
              {
                "id" => job.id,
                "employment_title" => job.employment_title,
                "employer" => {
                  "id" => job.employer.id,
                  "name" => job.employer.name,
                  "logo_url" => job.employer.logo_url
                },
                "starting_pay" => {
                  "employment_type" => "salary",
                  "upper_limit" => career_path.upper_limit.to_i,
                  "lower_limit" => career_path.lower_limit.to_i
                },
                "tags" => [tag.name],
                "location" => job.location,
                "industries" => job.industry,
                "saved" => true,
                "application_status" => "new"
              }
            )
          end
        end
      end
    end
  end
end
