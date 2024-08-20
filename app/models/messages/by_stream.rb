module Messages
  class ByStream < Filter
    def initialize(stream)
      super()
      @stream = stream
    end

    def execute(query_container)
      QueryContainer.new(
        relation: query_container.relation.where(aggregate_id: @stream.id),
        messages: query_container.messages.select { |m| m.schema == @stream }
      )
    end

    def post_query_execute(query_result)
      query_result.select { |m| m.schema.type == Core::EVENT }
    end
  end
end
