FactoryBot.define do
  factory :analytics__fact_candidate, class: "Analytics::FactCandidate" do
    dim_job_order factory: %i[analytics__dim_job_order]
    dim_person factory: %i[analytics__dim_person]

    status { "waiting on popcorn" }
    terminal_status_at { nil }
    order_candidate_number { 1 }
    added_at { Time.zone.local(2022, 1, 1) }
  end
end
