FactoryBot.define do
  factory :event_message do
    id { SecureRandom.uuid }
    aggregate_id { SecureRandom.uuid }
    version { 1 }

    Event::EventTypes::ALL.each do |event_type|
      trait event_type.to_sym do
        event_type { event_type }
        occurred_at { Time.zone.local(2020, 1, 1) }
        data { {} }
        metadata { {} }
      end
    end

    chat_message_sent

    initialize_with { EventMessage.new(**attributes) }
  end
end
