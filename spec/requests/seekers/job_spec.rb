require 'rails_helper'

RSpec.describe "Seekers::JobsController", type: :request do
  describe "GET /index" do
    subject { get '/seekers/jobs', headers:, params: }

    let(:params) { {} }

    context "When called without parameters" do
      # include_context "authenticated"

      it "calls the SeekerChats service" do
        expect(Jobs::SearchService)
          .to receive(:new)
          .with(
            search_terms: nil,
            industries: nil,
            tags: nil
          )
          .and_call_original

        subject
      end
    end

    context "When called with query parameters" do
      let(:params) do
        {
          search_terms: "Best Job",
          industries: ["Clowning"],
          tags: ["Funny clowns only"]
        }
      end

      it "calls the SeekerChats service" do
        expect(Jobs::SearchService)
          .to receive(:new)
          .with(
            search_terms: "Best Job",
            industries: ["Clowning"],
            tags: ["Funny clowns only"]
          )
          .and_call_original

        subject
      end
    end

    context "when unauthenticated" do
      it "calls the blueprint without a seekers" do
        expect(Jobs::JobBlueprint)
          .to receive(:render)
          .with(
            be_a(ActiveRecord::Relation),
            view: :seeker,
            seeker: nil
          )
          .and_call_original

        subject
      end
    end

    context "when authenticated" do
      include_context "authenticated"

      let!(:seeker) { create(:seeker, user:) }

      it "calls the blueprint with a seekers" do
        expect(Jobs::JobBlueprint)
          .to receive(:render)
          .with(
            be_a(ActiveRecord::Relation),
            view: :seeker,
            seeker:
          )
          .and_call_original

        subject
      end
    end
  end

  describe "POST /save" do
    subject { post job_save_path(job), headers: }

    let(:job) { create(:job) }

    it_behaves_like "a secured endpoint"

    context "when authenticated" do
      include_context "authenticated"

      it "calls the SeekerChats service" do
        expect(EventService)
          .to receive(:create!)
          .with(
            event_schema: Events::JobSaved::V1,
            aggregate_id: user.id,
            data: Events::Common::UntypedHashWrapper.new(
              job_id: job.id,
              employment_title: job.employment_title,
              employer_name: job.employer.name
            )
          )
          .and_call_original

        subject
      end
    end
  end

  describe "POST /unsave" do
    subject { post job_unsave_path(job), headers: }

    let(:job) { create(:job) }

    it_behaves_like "a secured endpoint"

    context "when authenticated" do
      include_context "authenticated"

      it "calls the SeekerChats service" do
        expect(EventService)
          .to receive(:create!)
          .with(
            event_schema: Events::JobUnsaved::V1,
            aggregate_id: user.id,
            data: Events::Common::UntypedHashWrapper.new(
              job_id: job.id,
              employment_title: job.employment_title,
              employer_name: job.employer.name
            )
          )
          .and_call_original

        subject
      end
    end
  end
end
