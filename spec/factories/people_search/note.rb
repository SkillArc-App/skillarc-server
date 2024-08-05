FactoryBot.define do
  factory :people_search__note, class: 'PeopleSearch::Note' do
    person factory: %i[coaches__person_context]

    note { "A note" }
  end
end
