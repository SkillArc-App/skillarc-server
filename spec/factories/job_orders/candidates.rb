FactoryBot.define do
  factory :job_orders__candidate, class: "JobOrders::Candidate" do
    association :job_order, factory: :job_orders__job_order
    association :seeker, factory: :job_orders__seeker

    applied_at { nil }
    status { JobOrders::CandidateStatus::ADDED }

    trait :applied do
      applied_at { Time.zone.local(2024, 1, 1) }
    end
  end
end
