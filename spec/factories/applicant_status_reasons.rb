FactoryBot.define do
  factory :applicant_status_reason do
    applicant
    reason
    response { "This canidate wasn't greate" }
  end
end
