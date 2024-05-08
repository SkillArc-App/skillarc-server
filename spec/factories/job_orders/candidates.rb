FactoryBot.define do
  factory :job_orders__candidate, class: "JobOrders::Candidate" do
    association :job_order, factory: :job_orders__job_order
    association :seeker, factory: :job_orders__seeker

    status { JobOrders::CandidateStatus::ADDED }
  end
end
