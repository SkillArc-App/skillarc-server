FactoryBot.define do
  factory :coaches__person_application, class: "Coaches::PersonApplication" do
    association :person_context, factory: :coaches__person_context

    job_id { SecureRandom.uuid }
    status { "Actively failing an interview" }
    employer_name { "Cool " }
    employment_title { "An application status" }
  end
end
