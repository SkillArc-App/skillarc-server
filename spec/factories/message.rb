FactoryBot.define do
  factory :message, class: "Message" do
    id { SecureRandom.uuid }

    transient do
      version { 1 }
      message_type { "chat_message_sent" }
      aggregate_id { SecureRandom.uuid }
    end

    schema { MessageService.get_schema(message_type:, version:) }
    trace_id { SecureRandom.uuid }
    aggregate { schema.aggregate.new(**{ schema.aggregate.id => aggregate_id }) }

    Messages::Types::ALL.each do |message_type|
      trait message_type.to_sym do
        schema { MessageService.get_schema(message_type:, version:) }
        occurred_at { Time.zone.local(2020, 1, 1) }
        data { Messages::Nothing }
        metadata { Messages::Nothing }
      end
    end

    chat_message_sent

    initialize_with { Message.new(**attributes) }
  end
end
