FactoryBot.define do
  factory :coaches__seeker_attribute, class: "Coaches::SeekerAttribute" do
    association :coach_seeker_context, factory: :coaches__coach_seeker_context
    id { SecureRandom.uuid }
    attribute_name { "Favorite Sport" }
    attribute_values { ["Football"] }
    attribute_id { SecureRandom.uuid }
  end
end
