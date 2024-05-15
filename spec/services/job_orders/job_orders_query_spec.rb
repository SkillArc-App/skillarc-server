require 'rails_helper'

RSpec.describe JobOrders::JobOrdersQuery do
  describe ".all_orders" do
    subject { described_class.all_orders }

    let!(:job1) { create(:job_orders__job, applicable_for_job_orders: true) }
    let!(:job2) { create(:job_orders__job, applicable_for_job_orders: false) }
    let!(:job_order1) { create(:job_orders__job_order, job: job1) }
    let!(:job_order2) { create(:job_orders__job_order, job: job2) }

    it "returns all orders which have applicable jobs" do
      expected_response = [
        {
          id: job_order1.id,
          employment_title: job1.employment_title,
          employer_name: job1.employer_name,
          opened_at: job_order1.opened_at,
          closed_at: job_order1.closed_at,
          order_count: job_order1.order_count,
          hire_count: job_order1.hire_count,
          recommended_count: job_order1.recommended_count,
          status: job_order1.status
        }
      ]

      expect(subject).to eq(expected_response)
    end
  end

  describe ".all_jobs" do
    subject { described_class.all_jobs }

    let!(:job1) { create(:job_orders__job, applicable_for_job_orders: true) }
    let!(:job2) { create(:job_orders__job, applicable_for_job_orders: false) }

    it "returns all orders which have applicable jobs" do
      expected_response = [
        {
          id: job1.id,
          employer_name: job1.employer_name,
          employer_id: job1.employer_id,
          employment_title: job1.employment_title
        }
      ]

      expect(subject).to eq(expected_response)
    end
  end

  describe ".find_order" do
    # TODO
  end
end
