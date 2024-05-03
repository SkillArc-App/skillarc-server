module Projections
  class GetLast
    def project(aggregate:)
      MessageService.aggregate_events(aggregate)
                    .select { |m| m.schema == schema }
                    .last
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
