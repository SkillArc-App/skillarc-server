require 'rails_helper'

RSpec.describe Jobs::SearchService do
  describe "#relevant_jobs" do
    subject { described_class.new(search_terms:, industries:, tags:).relevant_jobs }

    let(:search_terms) { nil }
    let(:industries) { nil }
    let(:tags) { nil }

    let!(:job1) { create(:job, employment_title: "Paid Friend", industry: ["Friendship"]) }
    let!(:job2) { create(:job, employment_title: "Bouncer", industry: ["Clubs", "Bodyguards"]) }
    let(:tag) { create(:tag, name: "Part Time") }
    let!(:job_tag) { create(:job_tag, job: job2, tag:) }

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
    end

    context "when industries are provided" do
      context "when induestries don't match anything" do
        let(:industries) { ["Poker"] }

        it "returns all no jobs" do
          expect(subject).to eq([])
        end
      end

      context "When there is overlap with industries" do
        let(:industries) { ["Friendship", "Baseball"] }

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
      let(:industries) { ["Clubs"] }
      let(:tags) { ["Part Time"] }

      it "returns the matching job" do
        expect(subject).to contain_exactly(job2)
      end
    end
  end
end
