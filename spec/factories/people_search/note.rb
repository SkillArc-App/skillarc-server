FactoryBot.define do
  factory :people_search__note, class: 'PeopleSearch::Note' do
    person factory: %i[people_search__person]

    note { "A note" }
  end
end
