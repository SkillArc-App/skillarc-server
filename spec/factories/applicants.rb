FactoryBot.define do
  factory :applicant do
    id { SecureRandom.uuid }
    job
    profile
    applicant_statuses do
      [
        build(:applicant_status, :new)
      ]
    end
  end
end
