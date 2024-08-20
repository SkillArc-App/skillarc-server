FactoryBot.define do
  factory :messages__query_container, class: 'Messages::QueryContainer' do
    messages { [build(:message)] }
    relation { Event.all }

    initialize_with do
      new(**attributes)
    end
  end
end
