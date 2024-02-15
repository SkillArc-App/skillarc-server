FactoryBot.define do
  factory :employers_job_owner, class: 'Employers::JobOwner' do
    job
    recruiter
  end
end
