module Projectors
  module Aggregates
    class GetLast
      def project
        MessageService.aggregate_events(aggregate)
                      .select { |m| m.schema == schema }
                      .last
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
