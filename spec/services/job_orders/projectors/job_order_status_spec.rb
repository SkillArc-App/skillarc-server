require 'rails_helper'

RSpec.describe JobOrders::Projectors::JobOrderStatus do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:aggregate) { Aggregates::JobOrder.new(job_order_id:) }
    let(:job_order_id) { SecureRandom.uuid }
    let(:person_id1) { SecureRandom.uuid }
    let(:person_id2) { SecureRandom.uuid }

    let(:job_order_not_filled) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderNotFilled::V1,
        data: Messages::Nothing
      )
    end
    let(:job_order_activated) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderActivated::V1,
        data: Messages::Nothing
      )
    end
    let(:job_order_order_count_added1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderOrderCountAdded::V1,
        data: {
          order_count: 2
        }
      )
    end
    let(:job_order_order_count_added2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderOrderCountAdded::V1,
        data: {
          order_count: 3
        }
      )
    end
    let(:job_order_candidate_added1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateAdded::V2,
        data: {
          person_id: person_id1
        }
      )
    end
    let(:job_order_candidate_added2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateAdded::V2,
        data: {
          person_id: person_id2
        }
      )
    end

    let(:job_order_candidate_recommended1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateRecommended::V2,
        data: {
          person_id: person_id1
        }
      )
    end
    let(:job_order_candidate_recommended2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateRecommended::V2,
        data: {
          person_id: person_id2
        }
      )
    end

    let(:job_order_candidate_hired1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateHired::V2,
        data: {
          person_id: person_id1
        }
      )
    end
    let(:job_order_candidate_hired2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateHired::V2,
        data: {
          person_id: person_id2
        }
      )
    end

    let(:job_order_candidate_rescinded1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateRescinded::V2,
        data: {
          person_id: person_id1
        }
      )
    end

    context "when a job order closed event has occured" do
      let(:messages) { [job_order_not_filled] }

      it "reports the status as the closed status" do
        expect(subject.status).to eq(JobOrders::ClosedStatus::NOT_FILLED)
      end

      context "when it's followed by an activation" do
        let(:messages) { [job_order_not_filled, job_order_activated] }

        it "reports the status as appropriate" do
          expect(subject.status).to eq(JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT)
        end
      end
    end

    context "when a job order has not been set occured but no order count has been set" do
      let(:messages) { [job_order_candidate_added1, job_order_candidate_recommended1, job_order_candidate_hired1] }

      it "reports the status as need order count" do
        expect(subject.status).to eq(JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT)
      end
    end

    context "when a job order has been set" do
      context "when no enough candidates have been recommended" do
        let(:messages) do
          [
            job_order_order_count_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1
          ]
        end

        it "reports the status as open" do
          expect(subject.status).to eq(JobOrders::ActivatedStatus::OPEN)
        end
      end

      context "when there enough candidates recommended" do
        let(:messages) do
          [
            job_order_order_count_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2
          ]
        end

        it "reports the status as waiting on employer" do
          expect(subject.status).to eq(JobOrders::StalledStatus::WAITING_ON_EMPLOYER)
        end
      end

      context "when enough hires have occurred" do
        let(:messages) do
          [
            job_order_order_count_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2,
            job_order_candidate_hired2
          ]
        end

        it "reports the status closed filled" do
          expect(subject.status).to eq(JobOrders::ClosedStatus::FILLED)
        end
      end

      context "when a rescinded hires to be the total too low" do
        let(:messages) do
          [
            job_order_order_count_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2,
            job_order_candidate_hired2,
            job_order_candidate_rescinded1
          ]
        end

        it "reports the status open" do
          expect(subject.status).to eq(JobOrders::ActivatedStatus::OPEN)
        end
      end

      context "when job order hire count is increased" do
        let(:messages) do
          [
            job_order_order_count_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2,
            job_order_candidate_hired2,
            job_order_order_count_added2
          ]
        end

        it "reports the status open" do
          expect(subject.status).to eq(JobOrders::ActivatedStatus::OPEN)
        end
      end
    end
  end
end
