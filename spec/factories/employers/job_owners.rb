FactoryBot.define do
  factory :employers_job_owner, class: 'Employers::JobOwner' do
    association :job, factory: :employers_job
    association :recruiter, factory: :employers_recruiter
  end
end
