FactoryBot.define do
  factory :analytics__dim_job, class: "Analytics::DimJob" do
    category { "some cateogry" }
    employment_title { "Best Job" }
    employment_type { "A type" }
    job_created_at { Time.zone.local(2020, 1, 1) }
    job_id { SecureRandom.uuid }
  end
end
