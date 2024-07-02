FactoryBot.define do
  factory :analytics__dim_job_order, class: "Analytics::DimJobOrder" do
    dim_job factory: %i[analytics__dim_job]

    job_order_id { SecureRandom.uuid }
    order_count { 1 }
    order_opened_at { Time.zone.local(2020, 1, 1) }
    closed_at { nil }
    closed_status { nil }
  end
end
