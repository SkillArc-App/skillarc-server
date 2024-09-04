FactoryBot.define do
  factory :coaches__person_attribute, class: "Coaches::PersonAttribute" do
    person_context factory: %i[coaches__person_context]
    id { SecureRandom.uuid }
    attribute_id { SecureRandom.uuid }
    machine_derived { false }
    attribute_value_ids { [SecureRandom.uuid] }
  end
end
