FactoryBot.define do
  factory :job_orders__application, class: "JobOrders::Application" do
    id { SecureRandom.uuid }
    association :job, factory: :job_orders__job
    association :seeker, factory: :job_orders__seeker

    status { ApplicantStatus::StatusTypes::NEW }
  end
end
