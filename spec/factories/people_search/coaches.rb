FactoryBot.define do
  factory :people_search__coach, class: 'PeopleSearch::Coach' do
    email { Faker::Internet.email }
  end
end
