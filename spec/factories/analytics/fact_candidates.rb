FactoryBot.define do
  factory :analytics__fact_candidate, class: "Analytics::FactCandidate" do
    dim_job_order factory: %i[analytics__dim_job_order]
    dim_person factory: %i[analytics__dim_person]

    status { JobOrders::CandidateStatus::SCREENED }
    status_started { Time.zone.local(2022, 1, 1) }
    status_ended { Time.zone.local(2022, 2, 1) }
  end
end
