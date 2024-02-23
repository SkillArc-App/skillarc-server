FactoryBot.define do
  factory :employers_applicant_status_reason, class: 'Employers::ApplicantStatusReason' do
    applicant

    reason { "This candidate did not meet the qualifications" }
    response { "Didn't show up to interview" }
  end
end
