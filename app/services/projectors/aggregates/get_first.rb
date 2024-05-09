module Projectors
  module Aggregates
    class GetFirst
      def project
        MessageService.aggregate_events(aggregate)
                      .select { |m| m.schema == schema }
                      .first
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
