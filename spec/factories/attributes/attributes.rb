FactoryBot.define do
  factory :attributes_attribute, class: 'Attributes::Attribute' do
    transient do
      id1 { SecureRandom.uuid }
      id2 { SecureRandom.uuid }
    end

    name { "attribute_name" }
    set { { id1 => "1", id2 => "2" } }
    default { { id1 => "1" } }
    machine_derived { false }
  end
end
