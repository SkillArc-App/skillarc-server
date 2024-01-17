FactoryBot.define do
  factory :coaches__seeker_application, class: "Coaches::SeekerApplication" do
    association :coach_seeker_context, factory: :coaches__coach_seeker_context

    application_id { SecureRandom.uuid }
    status { "This is a note" }
    employment_title { "An application status" }
  end
end
