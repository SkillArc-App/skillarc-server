FactoryBot.define do
  factory :employers_applicant, class: 'Employers::Applicant' do
    association :employer, factory: :employers_employer
  end
end
