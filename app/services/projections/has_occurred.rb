module Projections
  class HasOccurred
    def project(aggregate:)
      MessageService.aggregate_events(aggregate).detect { |m| m.schema == schema }.present?
    end

    def initialize(schema:)
      @schema = schema
    end

    def self.project(aggregate:, schema:)
      instance = new(schema:)
      instance.project(aggregate:)
    end

    private

    attr_reader :schema
  end
end
