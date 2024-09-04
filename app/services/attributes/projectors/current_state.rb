module Attributes
  module Projectors
    class CurrentState < Projector
      projection_stream Streams::Attribute

      class Projection
        extend Record

        schema do
          set ArrayOf(Core::UuidKeyValuePair)
        end
      end

      def init
        Projection.new(set: [])
      end

      on_message Events::Created::V4 do |message, accumulator|
        accumulator.with(set: message.data.set)
      end

      on_message Events::Updated::V3 do |message, accumulator|
        accumulator.with(set: message.data.set)
      end

      on_message Events::Deleted::V2 do |_, accumulator|
        accumulator.with(set: [])
      end
    end
  end
end
