FactoryBot.define do
  factory :job_search__application, class: "JobSearch::Application" do
    association :search_job, factory: :job_search__job

    status { ApplicantStatus::StatusTypes::NEW }
    job_id { SecureRandom.uuid }
    application_id { SecureRandom.uuid }
    seeker_id { SecureRandom.uuid }
  end
end
