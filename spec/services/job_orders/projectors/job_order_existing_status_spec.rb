require 'rails_helper'

RSpec.describe JobOrders::Projectors::JobOrderExistingStatus do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:stream) { JobOrders::Streams::JobOrder.new(job_order_id:) }
    let(:job_order_id) { SecureRandom.uuid }
    let(:status1) { JobOrders::ActivatedStatus::OPEN }
    let(:status2) { JobOrders::StalledStatus::WAITING_ON_EMPLOYER }

    let(:now) { Time.zone.now }

    let(:job_order_status_updated1) do
      build(
        :message,
        stream:,
        schema: JobOrders::Events::StatusUpdated::V1,
        data: {
          status: status1
        }
      )
    end
    let(:job_order_status_updated2) do
      build(
        :message,
        stream:,
        schema: JobOrders::Events::StatusUpdated::V1,
        data: {
          status: status2
        }
      )
    end

    context "when there are no events" do
      let(:messages) { [] }

      it "return the open status" do
        expect(subject.status).to eq(JobOrders::ActivatedStatus::NEEDS_ORDER_COUNT)
      end
    end

    context "when there are events" do
      let(:messages) { [job_order_status_updated1, job_order_status_updated2] }

      it "return the last status" do
        expect(subject.status).to eq(status2)
      end
    end
  end
end
