FactoryBot.define do
  factory :people_search__person_experience, class: 'PeopleSearch::PersonExperience' do
    position { "Welder" }
    organization_name { "Welding Inc." }
    description { "Welded things" }
  end
end
