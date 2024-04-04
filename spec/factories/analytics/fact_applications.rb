FactoryBot.define do
  factory :analytics__fact_application, class: "Analytics::FactApplication" do
    association :dim_job, factory: :analytics__dim_job
    association :dim_person, factory: :analytics__dim_person

    status { "going_places" }
    application_id { SecureRandom.uuid }
    application_number { 1 }
    application_opened_at { Time.zone.local(2022, 1, 1) }
  end
end
