module Messages
  class BySchema < Filter
    QueriedInactiveSchemaError = Class.new(StandardError)

    def initialize(schema, active_only: true)
      super()
      @schema = schema
      @active_only = active_only
    end

    def execute(query_container)
      raise QueriedInactiveSchemaError if @active_only && !@schema.active?

      QueryContainer.new(
        relation: query_container.relation.where(version: @schema.version, event_type: @schema.message_type),
        messages: query_container.messages.select { |m| m.schema == @schema }
      )
    end

    def post_query_execute(query_result)
      query_result
    end
  end
end
