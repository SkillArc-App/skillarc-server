FactoryBot.define do
  factory :job_orders__job_order, class: "JobOrders::JobOrder" do
    id { SecureRandom.uuid }
    association :job, factory: :job_orders__job
    opened_at { Time.zone.now }

    status { JobOrders::ActivatedStatus::OPEN }
    applicant_count { 0 }
    candidate_count { 0 }
    closed_at { nil }
    hire_count { 2 }
    order_count { 5 }
    recommended_count { 0 }
  end
end
