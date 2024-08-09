FactoryBot.define do
  factory :analytics__fact_job_order_status, class: "Analytics::FactJobOrderStatus" do
    dim_job_order factory: %i[analytics__dim_job_order]

    status { JobOrders::OrderStatus::OPEN }
    status_started { Time.zone.local(2022, 1, 1) }
    status_ended { Time.zone.local(2022, 2, 1) }
  end
end
