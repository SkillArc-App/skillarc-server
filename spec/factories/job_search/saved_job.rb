FactoryBot.define do
  factory :job_search__saved_job, class: "JobSearch::SavedJob" do
    association :search_job, factory: :job_search__job
    user_id { SecureRandom.uuid }
  end
end
