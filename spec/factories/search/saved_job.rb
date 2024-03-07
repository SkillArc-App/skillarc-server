FactoryBot.define do
  factory :search__saved_job, class: "Search::SavedJob" do
    association :search_job, factory: :search__job
    user_id { SecureRandom.uuid }
  end
end
