FactoryBot.define do
  factory :applicant do
    id { SecureRandom.uuid }
    job
    seeker
    applicant_statuses do
      [
        build(:applicant_status, :new)
      ]
    end
  end
end
