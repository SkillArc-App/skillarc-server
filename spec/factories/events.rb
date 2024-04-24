FactoryBot.define do
  factory :event do
    transient do
      schema { Events::ChatMessageSent::V1 }
    end

    id { SecureRandom.uuid }
    aggregate_id { SecureRandom.uuid }
    trace_id { SecureRandom.uuid }
    chat_message_sent
    event_type { schema.message_type }

    version { schema.version }
    occurred_at { Time.zone.local(2020, 1, 1) }
    data { {} }
    metadata { {} }

    Messages::Types::ALL.each do |message_type|
      trait message_type.to_sym do
        event_type { message_type }
      end
    end
  end
end
