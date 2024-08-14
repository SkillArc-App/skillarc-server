module People
  module Projectors
    class Attributes < Projector
      projection_stream Streams::Person

      class PersonAttribute
        extend Record

        schema do
          id Uuid
          values ArrayOf(String)
        end
      end

      class Projection
        extend Record

        schema do
          attributes HashOf(String => PersonAttribute)
        end
      end

      def init
        Projection.new(
          attributes: {}
        )
      end

      on_message Events::PersonAttributeAdded::V1 do |message, accumulator|
        person_attribute = PersonAttribute.new(
          id: message.data.attribute_id,
          values: message.data.attribute_values
        )

        Projection.new(attributes: accumulator.attributes.merge({ message.data.id => person_attribute }))
      end

      on_message Events::PersonAttributeRemoved::V1 do |message, accumulator|
        Projection.new(attributes: accumulator.attributes.reject { |k, _| k == message.data.id })
      end
    end
  end
end
