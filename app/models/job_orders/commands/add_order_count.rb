module JobOrders
  module Commands
    module AddOrderCount
      module Data
        class V1
          extend Core::Payload

          schema do
            order_count 1..
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::JobOrder,
        message_type: MessageTypes::ADD_ORDER_COUNT,
        version: 1
      )
    end
  end
end
