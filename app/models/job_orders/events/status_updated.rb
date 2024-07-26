module JobOrders
  module Events
    module StatusUpdated
      module Data
        class V1
          extend Core::Payload

          schema do
            status Either(*OrderStatus::ALL)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::STATUS_UPDATED,
        version: 1
      )
    end
  end
end
