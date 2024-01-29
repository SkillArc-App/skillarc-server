module Events
  class Schema
    attr_reader :data, :metadata, :event_type, :version

    def self.build(data:, metadata:, event_type:, version:)
      event_schema = new(data:, metadata:, event_type:, version:)
      EventService.register(event_schema:)
      event_schema
    end

    private

    def initialize(data:, metadata:, event_type:, version:)
      @data = data
      @metadata = metadata
      @event_type = event_type
      @version = version
    end
  end
end
