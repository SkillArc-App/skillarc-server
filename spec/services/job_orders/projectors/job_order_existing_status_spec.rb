require 'rails_helper'

RSpec.describe JobOrders::Projectors::JobOrderExistingStatus do
  describe ".project" do
    subject { described_class.project(aggregate:) }

    let(:aggregate) { Aggregates::JobOrder.new(job_order_id:) }
    let(:job_order_id) { SecureRandom.uuid }

    before do
      allow(MessageService)
        .to receive(:aggregate_events)
        .with(aggregate)
        .and_return(messages)
    end

    let(:now) { Time.zone.now }

    let(:job_order_activated) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderActivated::V1,
        data: Messages::Nothing
      )
    end
    let(:job_order_stalled) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderStalled::V1,
        data: {
          status: JobOrders::IdleStatus::WAITING_ON_EMPLOYER
        }
      )
    end
    let(:job_order_closed) do
      build(
        :message,
        aggregate:,
        schema: Events::JobOrderClosed::V1,
        data: {
          status: JobOrders::CloseStatus::FILLED
        }
      )
    end

    context "when the last event was activated" do
      let(:messages) { [job_order_closed, job_order_stalled, job_order_activated] }

      it "return the open status" do
        expect(subject.status).to eq(JobOrders::OpenStatus::OPEN)
      end
    end

    context "when the last event was stalled" do
      let(:messages) { [job_order_closed, job_order_activated, job_order_stalled] }

      it "return the open status" do
        expect(subject.status).to eq(job_order_stalled.data.status)
      end
    end

    context "when the last event was closed" do
      let(:messages) { [job_order_activated, job_order_stalled, job_order_closed] }

      it "return the open status" do
        expect(subject.status).to eq(job_order_closed.data.status)
      end
    end
  end
end
