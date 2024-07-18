FactoryBot.define do
  factory :analytics_fact_job_order_status, class: 'Analytics::FactJobOrderStatus' do
    started_at { Time.zone.local(2020, 1, 1) }
  end
end
