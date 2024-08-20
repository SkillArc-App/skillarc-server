module Messages
  class Query
    extend Record
    NoFilterError = Class.new(StandardError)

    schema do
      query_container QueryContainer
      filters ArrayOf(Filter), default: []
    end

    def by_stream(stream)
      with_filter(ByStream.new(stream))
    end

    def by_trace(trace_id)
      with_filter(ByTrace.new(trace_id))
    end

    def by_schema(schema, active_only: true)
      with_filter(BySchema.new(schema, active_only:))
    end

    def before(message)
      with_filter(Before.new(message))
    end

    def exists?
      raise NoFilterError if @filters.empty?

      query_container = @query_container

      @filters.each do |filter|
        query_container = filter.execute(query_container)
      end

      query_container.relation.exists? || !query_container.messages.empty?
    end

    def fetch
      raise NoFilterError if @filters.empty?

      query_container = @query_container

      @filters.each do |filter|
        query_container = filter.execute(query_container)
      end

      messages = query_container.relation.map(&:message)

      # Basically a hack until we fix the message store
      @filters.each do |filter|
        messages = filter.post_query_execute(messages)
      end

      messages += query_container.messages

      messages.sort do |m1, m2|
        result = m1.occurred_at <=> m2.occurred_at
        next result if result != 0

        m1.id <=> m2.id
      end
    end

    private

    def with_filter(filter)
      Query.new(
        query_container:,
        filters: filters + [filter]
      )
    end
  end
end
