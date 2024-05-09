module Projectors
  module Aggregates
    class HasOccurred
      def project
        MessageService.aggregate_events(aggregate).detect { |m| m.schema == schema }.present?
      end

      def initialize(schema:, aggregate:)
        @schema = schema
        @aggregate = aggregate
      end

      def self.project(aggregate:, schema:)
        instance = new(schema:, aggregate:)
        instance.project
      end

      private

      attr_reader :schema, :aggregate
    end
  end
end
