FactoryBot.define do
  factory :job_orders__note, class: "JobOrders::Note" do
    id { SecureRandom.uuid }
    association :job_order, factory: :job_orders__job_order

    note { "This is a note" }
    note_taken_at { Time.zone.local(2021, 4, 1) }
    note_taken_by { "david@skillarc.com" }
  end
end
