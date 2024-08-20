module Messages
  class ByTrace < Filter
    def initialize(trace_id)
      super()
      @trace_id = trace_id
    end

    def execute(query_container)
      QueryContainer.new(
        relation: query_container.relation.where(trace_id: @trace_id),
        messages: query_container.messages.select { |m| m.trace_id == @trace_id }
      )
    end

    def post_query_execute(query_result)
      query_result.select { |m| m.schema.type == Core::EVENT }
    end
  end
end
