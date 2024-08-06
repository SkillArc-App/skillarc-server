FactoryBot.define do
  factory :people_search__attribute_person, class: 'PeopleSearch::AttributePerson' do
    id { SecureRandom.uuid }
    person factory: %i[people_search__person]
    person_attribute factory: %i[people_search__attribute]
  end
end
