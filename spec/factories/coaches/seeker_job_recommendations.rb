FactoryBot.define do
  factory :coaches__seeker_job_recommendation, class: "Coaches::SeekerJobRecommendation" do
    association :coach_seeker_context, factory: :coaches__coach_seeker_context
    association :job, factory: :coaches__job
    association :coach, factory: :coaches__coach
  end
end
