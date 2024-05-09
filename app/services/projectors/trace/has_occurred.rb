module Projectors
  module Trace
    class HasOccurred
      def project
        MessageService.trace_id_events(trace_id).detect { |m| m.schema == schema }.present?
      end

      def initialize(schema:, trace_id:)
        @schema = schema
        @trace_id = trace_id
      end

      def self.project(trace_id:, schema:)
        instance = new(schema:, trace_id:)
        instance.project
      end

      private

      attr_reader :schema, :trace_id
    end
  end
end
