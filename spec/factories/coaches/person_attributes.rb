FactoryBot.define do
  factory :coaches__person_attribute, class: "Coaches::PersonAttribute" do
    association :person_context, factory: :coaches__person_context
    id { SecureRandom.uuid }
    attribute_id { SecureRandom.uuid }
    name { "Favorite Sport" }
    values { ["Football"] }
  end
end
