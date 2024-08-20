module Messages
  class Before < Filter
    def initialize(message)
      super()
      @message = message
    end

    def execute(query_container)
      QueryContainer.new(
        relation: query_container.relation.where(occurred_at: ..@message.occurred_at),
        messages: query_container.messages.select { |m| m.occurred_at < @message.occurred_at }
      )
    end

    def post_query_execute(query_result)
      query_result
    end
  end
end
