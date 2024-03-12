FactoryBot.define do
  factory :search__application, class: "Search::Application" do
    association :search_job, factory: :search__job

    status { ApplicantStatus::StatusTypes::NEW }
    job_id { SecureRandom.uuid }
    application_id { SecureRandom.uuid }
    seeker_id { SecureRandom.uuid }
  end
end
