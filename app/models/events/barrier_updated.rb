module Events
  module BarrierUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          barriers ArrayOf(String)
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::BARRIERS_UPDATED,
      version: 1
    )
  end
end
