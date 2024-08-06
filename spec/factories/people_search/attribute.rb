FactoryBot.define do
  factory :people_search__attribute, class: 'PeopleSearch::Attribute' do
    value { "Cool" }
    attribute_id { SecureRandom.uuid }
  end
end
