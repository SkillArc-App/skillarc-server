FactoryBot.define do
  factory :message, class: "Message" do
    id { SecureRandom.uuid }

    transient do
      aggregate_id { SecureRandom.uuid }
    end

    schema { Events::SessionStarted::V1 }
    trace_id { SecureRandom.uuid }
    aggregate { schema.aggregate.new(**{ schema.aggregate.id => aggregate_id }) }
    occurred_at { Time.zone.local(2020, 1, 1) }
    data { Messages::Nothing }
    metadata { Messages::Nothing }

    initialize_with do
      data =
        if attributes[:data].is_a?(Hash)
          attributes[:schema].data.new(**attributes[:data])
        else
          attributes[:data]
        end
      metadata =
        if attributes[:metadata].is_a?(Hash)
          attributes[:schema].metadata.new(**attributes[:metadata])
        else
          attributes[:metadata]
        end

      Message.new(
        **attributes,
        data:,
        metadata:
      )
    end
  end
end
