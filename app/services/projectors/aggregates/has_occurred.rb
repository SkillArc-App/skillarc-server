module Projectors
  module Aggregates
    class HasOccurred
      def project(messages)
        messages.detect { |m| m.schema == schema }.present?
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
