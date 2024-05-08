require 'rails_helper'

RSpec.describe JobOrders::Projections::JobOrderStatus do
  describe ".project" do
    subject { described_class.project(aggregate:) }

    let(:aggregate) { Aggregates::JobOrder.new(job_order_id:) }
    let(:job_order_id) { SecureRandom.uuid }
    let(:seeker_id1) { SecureRandom.uuid }
    let(:seeker_id2) { SecureRandom.uuid }

    before do
      allow(MessageService)
        .to receive(:aggregate_events)
        .with(aggregate)
        .and_return(messages)
    end

    let(:job_order_closed) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderClosed::V1,
        data: {
          status: JobOrders::CloseStatus::NOT_FILLED
        }
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
    let(:job_order_added1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderAdded::V1,
        data: {
          job_id: SecureRandom.uuid,
          order_count: 2
        }
      )
    end
    let(:job_order_added2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderAdded::V1,
        data: {
          job_id: SecureRandom.uuid,
          order_count: 3
        }
      )
    end
    let(:job_order_candidate_added1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateAdded::V1,
        data: {
          seeker_id: seeker_id1
        }
      )
    end
    let(:job_order_candidate_added2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateAdded::V1,
        data: {
          seeker_id: seeker_id2
        }
      )
    end

    let(:job_order_candidate_recommended1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateRecommended::V1,
        data: {
          seeker_id: seeker_id1
        }
      )
    end
    let(:job_order_candidate_recommended2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateRecommended::V1,
        data: {
          seeker_id: seeker_id2
        }
      )
    end

    let(:job_order_candidate_hired1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateHired::V1,
        data: {
          seeker_id: seeker_id1
        }
      )
    end
    let(:job_order_candidate_hired2) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateHired::V1,
        data: {
          seeker_id: seeker_id2
        }
      )
    end

    let(:job_order_candidate_rescinded1) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderCandidateRescinded::V1,
        data: {
          seeker_id: seeker_id1
        }
      )
    end

    context "when an invalid transistion occurs" do
      let(:messages) { [job_order_candidate_recommended1] }

      it "raises and invalid transistion error" do
        expect { subject }.to raise_error(described_class::InvalidTransitionError)
      end
    end

    context "when a job order closed event has occured" do
      let(:messages) { [job_order_closed] }

      it "reports the status as the closed status" do
        expect(subject.status).to eq(JobOrders::CloseStatus::NOT_FILLED)
      end

      context "when it's followed by an activation" do
        let(:messages) { [job_order_closed, job_order_activated] }

        it "reports the status as appropriate" do
          expect(subject.status).to eq(JobOrders::OpenStatus::OPEN)
        end
      end
    end

    context "when a job order has not been set occured but no order count has been set" do
      let(:messages) { [job_order_candidate_added1, job_order_candidate_recommended1, job_order_candidate_hired1] }

      it "reports the status as open" do
        expect(subject.status).to eq(JobOrders::OpenStatus::OPEN)
      end
    end

    context "when a job order has been set" do
      context "when no enough candidates have been recommended" do
        let(:messages) do
          [
            job_order_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1
          ]
        end

        it "reports the status as open" do
          expect(subject.status).to eq(JobOrders::OpenStatus::OPEN)
        end
      end

      context "when there enough candidates recommended" do
        let(:messages) do
          [
            job_order_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2
          ]
        end

        it "reports the status as waiting on employer" do
          expect(subject.status).to eq(JobOrders::IdleStatus::WAITING_ON_EMPLOYER)
        end
      end

      context "when enough hires have occurred" do
        let(:messages) do
          [
            job_order_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2,
            job_order_candidate_hired2
          ]
        end

        it "reports the status closed filled" do
          expect(subject.status).to eq(JobOrders::CloseStatus::FILLED)
        end
      end

      context "when a rescinded hires to be the total too low" do
        let(:messages) do
          [
            job_order_added1,
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
          expect(subject.status).to eq(JobOrders::OpenStatus::OPEN)
        end
      end

      context "when job order hire count is increased" do
        let(:messages) do
          [
            job_order_added1,
            job_order_candidate_added1,
            job_order_candidate_recommended1,
            job_order_candidate_hired1,
            job_order_candidate_added2,
            job_order_candidate_recommended2,
            job_order_candidate_hired2,
            job_order_added2
          ]
        end

        it "reports the status open" do
          expect(subject.status).to eq(JobOrders::OpenStatus::OPEN)
        end
      end
    end
  end
end
