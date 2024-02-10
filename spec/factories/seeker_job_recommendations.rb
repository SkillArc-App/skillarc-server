FactoryBot.define do
  factory :seeker_job_recommendation do
    coaches__coach_seeker_context
    coaches__job
    coaches__coach
  end
end
