module People
  module Projectors
    class Name < Projector
      projection_aggregator Aggregates::Person

      class Projection
        extend Record

        schema do
          first_name Either(String, nil)
          last_name Either(String, nil)
        end
      end

      def init
        Projection.new(
          first_name: nil,
          last_name: nil
        )
      end

      on_message Events::PersonAdded::V1 do |message, accumulator|
        accumulator.with(
          first_name: message.data.first_name,
          last_name: message.data.last_name
        )
      end

      on_message Events::BasicInfoAdded::V1 do |message, accumulator|
        accumulator.with(
          first_name: message.data.first_name,
          last_name: message.data.last_name
        )
      end
    end
  end
end
