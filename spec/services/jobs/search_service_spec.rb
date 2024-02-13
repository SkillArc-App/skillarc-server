require 'rails_helper'

RSpec.describe Jobs::SearchService do
  describe "#relevant_jobs" do
    subject { described_class.new(search_terms:, industries:, tags:).relevant_jobs(user:, utm_source:) }

    let(:search_terms) { nil }
    let(:industries) { nil }
    let(:tags) { nil }
    let(:user) { nil }

    let!(:job1) { create(:job, employment_title: "Paid Friend", industry: [construction]) }
    let!(:job2) { create(:job, employment_title: "Bouncer", industry: [healthcare, manufacturing]) }
    let(:tag) { create(:tag, name: "Part Time") }
    let!(:job_tag) { create(:job_tag, job: job2, tag:) }
    let(:utm_source) { "www.google.com" }
    let(:construction) { Job::Industries::CONSTRUCTION }
    let(:healthcare) { Job::Industries::HEALTHCARE }
    let(:logistics) { Job::Industries::LOGISTICS }
    let(:manufacturing) { Job::Industries::MANUFACTURING }

    context "search source" do
      let(:search_terms) { "oun" }
      let(:industries) { [construction] }
      let(:tags) { ["Part Time"] }

      context "when user is nil" do
        it "emits a search event for unauthenticated" do
          expect(EventService)
            .to receive(:create!)
            .with(
              event_schema: Events::JobSearch::V2,
              data: Events::JobSearch::Data::V1.new(
                search_terms:,
                industries:,
                tags:
              ),
              aggregate_id: 'unauthenticated',
              metadata: Events::JobSearch::MetaData::V2.new(
                source: "unauthenticated",
                utm_source:
              )
            )

          subject
        end
      end

      context "when user doesn't have a seeker" do
        let(:user) { create(:user) }

        it "emits a search event for a non-seeker" do
          expect(EventService)
            .to receive(:create!)
            .with(
              event_schema: Events::JobSearch::V2,
              data: Events::JobSearch::Data::V1.new(
                search_terms:,
                industries:,
                tags:
              ),
              aggregate_id: user.id,
              metadata: Events::JobSearch::MetaData::V2.new(
                source: "user",
                id: user.id,
                utm_source:
              )
            )

          subject
        end
      end

      context "when user does have a seeker" do
        let(:user) { seeker.user }
        let(:seeker) { create(:seeker) }

        it "emits a search event for a non-seeker" do
          expect(EventService)
            .to receive(:create!)
            .with(
              event_schema: Events::JobSearch::V2,
              data: Events::JobSearch::Data::V1.new(
                search_terms:,
                industries:,
                tags:
              ),
              aggregate_id: user.id,
              metadata: Events::JobSearch::MetaData::V2.new(
                source: "seeker",
                id: user.id,
                utm_source:
              )
            )

          subject
        end
      end
    end

    context "when no constraints are provided" do
      it "returns all jobs" do
        expect(subject).to contain_exactly(job1, job2)
      end
    end

    context "when search terms are provided" do
      context "when the search terms doesn't match anything" do
        let(:search_terms) { "Zoo Person" }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "when the search terms is less than three characters" do
        let(:search_terms) { "a" }

        it "is ignored and returns all jobs" do
          expect(subject).to contain_exactly(job1, job2)
        end
      end

      context "when the search terms match a job" do
        let(:search_terms) { "Friend" }

        it "returns all no jobs" do
          expect(subject).to contain_exactly(job1)
        end
      end

      context "when the search terms case insenstive match a job" do
        let(:search_terms) { "friend" }

        it "returns all no jobs" do
          expect(subject).to contain_exactly(job1)
        end
      end
    end

    context "when industries are provided" do
      context "when induestries don't match anything" do
        let(:industries) { ["Poker"] }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "When there is overlap with industries" do
        let(:industries) { [construction, logistics] }

        it "returns all no jobs" do
          expect(subject).to contain_exactly(job1)
        end
      end
    end

    context "when tags are provided" do
      context "when tags don't match anything" do
        let(:tags) { ["Certified Lame"] }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "When there is overlap with industries" do
        let(:tags) { ["Certified Fun", "Part Time"] }

        it "returns all no jobs" do
          expect(subject).to contain_exactly(job2)
        end
      end
    end

    context "when everything is used" do
      let(:search_terms) { "oun" }
      let(:industries) { [healthcare] }
      let(:tags) { ["Part Time"] }

      it "returns the matching job" do
        expect(subject).to contain_exactly(job2)
      end
    end
  end
end
