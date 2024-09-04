module Jobs
  module Projectors
    class Attributes < Projector
      projection_stream Streams::Job

      class Attribute
        extend Record

        schema do
          id Uuid
          acceptible_set ArrayOf(String)
        end
      end

      class Projection
        extend Record

        schema do
          attributes HashOf(Uuid => Attribute)
        end
      end

      def init
        Projection.new(attributes: {})
      end

      on_message Events::JobAttributeCreated::V2 do |message, accumulator|
        accumulator.attributes[message.data.job_attribute_id] = Attribute.new(
          id: message.data.attribute_id,
          acceptible_set: message.data.acceptible_set
        )
        accumulator
      end

      on_message Events::JobAttributeUpdated::V2 do |message, accumulator|
        accumulator.attributes[message.data.job_attribute_id] = accumulator.attributes[message.data.job_attribute_id].with(
          acceptible_set: message.data.acceptible_set
        )
        accumulator
      end

      on_message Events::JobAttributeDestroyed::V2 do |message, accumulator|
        accumulator.attributes.delete(message.data.job_attribute_id)
        accumulator
      end
    end
  end
end
