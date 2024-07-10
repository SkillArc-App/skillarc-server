module Projectors
  module Streams
    class GetLast
      def project(messages)
        messages
          .select { |m| m.schema == schema }
          .last
      end

      def initialize(schema:)
        @schema = schema
      end

      def self.project(aggregate:, schema:)
        messages = MessageService.aggregate_events(aggregate)
        instance = new(schema:)
        instance.project(messages)
      end

      private

      attr_reader :schema, :aggregate
    end
  end
end
