FactoryBot.define do
  factory :job_orders__job, class: "JobOrders::Job" do
    id { SecureRandom.uuid }
    employer_name { "An employer" }
    employment_title { "A job" }
    employer_id { SecureRandom.uuid }
  end
end
