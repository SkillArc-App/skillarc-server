FactoryBot.define do
  factory :coaches__person_job_recommendation, class: "Coaches::PersonJobRecommendation" do
    association :person_context, factory: :coaches__person_context
    association :job, factory: :coaches__job
    association :coach, factory: :coaches__coach
  end
end
