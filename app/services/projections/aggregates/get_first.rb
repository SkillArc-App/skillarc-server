module Projections
  module Aggregates
    class GetFirst
      def project(aggregate:)
        MessageService.aggregate_events(aggregate)
                      .select { |m| m.schema == schema }
                      .first
      end

      def initialize(schema:)
        @schema = schema
      end

      def self.project(aggregate:, schema:)
        instance = new(schema:)
        instance.project(aggregate:)
      end

      private

      attr_reader :schema, :attribute
    end
  end
end
