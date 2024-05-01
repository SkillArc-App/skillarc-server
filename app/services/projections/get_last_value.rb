module Projections
  class GetLastValue
    def project(aggregate:)
      MessageService.aggregate_events(aggregate)
                    .select { |m| m.schema == schema }
                    .map { |m| m.data.send(attribute) }
                    .last
    end

    def initialize(schema:, attribute:)
      @schema = schema
      @attribute = attribute
    end

    def self.project(aggregate:, schema:, attribute:)
      instance = new(schema:, attribute:)
      instance.project(aggregate:)
    end

    private

    attr_reader :schema, :attribute
  end
end
