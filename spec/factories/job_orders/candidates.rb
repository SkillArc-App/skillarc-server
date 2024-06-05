FactoryBot.define do
  factory :job_orders__candidate, class: "JobOrders::Candidate" do
    association :job_order, factory: :job_orders__job_order
    association :person, factory: :job_orders__person

    applied_at { nil }
    added_at { Time.zone.local(2022, 1, 1) }
    status { JobOrders::CandidateStatus::ADDED }

    trait :applied do
      applied_at { Time.zone.local(2024, 1, 1) }
    end
  end
end
