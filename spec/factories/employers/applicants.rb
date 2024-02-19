FactoryBot.define do
  factory :employers_applicant, class: 'Employers::Applicant' do
    association :job, factory: :employers_job
  end
end
