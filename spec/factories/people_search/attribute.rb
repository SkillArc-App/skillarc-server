FactoryBot.define do
  factory :people_search__attribute, class: 'PeopleSearch::Attribute' do
    attribute_value_id { SecureRandom.uuid }
    attribute_id { SecureRandom.uuid }
  end
end
