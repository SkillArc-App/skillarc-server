require 'rails_helper'

RSpec.describe "Seekers::JobsController", type: :request do
  describe "GET /index" do
    subject { get '/seekers/jobs', headers:, params: }

    let(:params) { {} }

    let(:search_service) do
      Jobs::SearchService.new(
        search_terms: params[:utm_term],
        industries: params[:industries],
        tags: params[:tags]
      )
    end

    context "when unauthenticated" do
      context "When called without parameters" do
        it "Creates a search service and sets the source params" do
          expect(Jobs::SearchService)
            .to receive(:new)
            .with(
              search_terms: nil,
              industries: nil,
              tags: nil
            )
            .and_return(search_service)

          expect(search_service)
            .to receive(:relevant_jobs)
            .with(
              user: nil,
              utm_source: nil
            ).and_call_original

          expect(Jobs::JobBlueprint)
            .to receive(:render)
            .with(
              be_a(ActiveRecord::Relation),
              view: :seeker,
              user: nil
            )
            .and_call_original

          subject
        end
      end

      context "When called with query parameters" do
        let(:params) do
          {
            utm_term: "Best Job",
            industries: ["Clowning"],
            tags: ["Funny clowns only"],
            utm_source: "www.google.com"
          }
        end

        it "Creates a search service and sets the source params" do
          expect(Jobs::SearchService)
            .to receive(:new)
            .with(
              search_terms: "Best Job",
              industries: ["Clowning"],
              tags: ["Funny clowns only"]
            )
            .and_return(search_service)

          expect(search_service)
            .to receive(:relevant_jobs)
            .with(
              user: nil,
              utm_source: params[:utm_source]
            ).and_call_original

          expect(Jobs::JobBlueprint)
            .to receive(:render)
            .with(
              be_a(ActiveRecord::Relation),
              view: :seeker,
              user: nil
            )
            .and_call_original

          subject
        end
      end
    end

    context "when authenticated" do
      include_context "authenticated"

      let!(:seeker) { create(:seeker, user:) }

      context "When called without parameters" do
        it "Creates a search service and sets the source params" do
          expect(Jobs::SearchService)
            .to receive(:new)
            .with(
              search_terms: nil,
              industries: nil,
              tags: nil
            )
            .and_return(search_service)

          expect(search_service)
            .to receive(:relevant_jobs)
            .with(
              user:,
              utm_source: nil
            ).and_call_original

          expect(Jobs::JobBlueprint)
            .to receive(:render)
            .with(
              be_a(ActiveRecord::Relation),
              view: :seeker,
              user:
            )
            .and_call_original

          subject
        end
      end

      context "When called with query parameters" do
        let(:params) do
          {
            utm_term: "Best Job",
            industries: ["Clowning"],
            tags: ["Funny clowns only"],
            utm_source: "www.google.com"
          }
        end

        it "Creates a search service and sets the source params" do
          expect(Jobs::SearchService)
            .to receive(:new)
            .with(
              search_terms: "Best Job",
              industries: ["Clowning"],
              tags: ["Funny clowns only"]
            )
            .and_return(search_service)

          expect(search_service)
            .to receive(:relevant_jobs)
            .with(
              user:,
              utm_source: params[:utm_source]
            ).and_call_original

          expect(Jobs::JobBlueprint)
            .to receive(:render)
            .with(
              be_a(ActiveRecord::Relation),
              view: :seeker,
              user:
            )
            .and_call_original

          subject
        end
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
            user:
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
            user_id: user.id,
            data: Messages::UntypedHashWrapper.new(
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
            user_id: user.id,
            data: Messages::UntypedHashWrapper.new(
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
