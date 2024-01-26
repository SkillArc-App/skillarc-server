module Events
  class Schema
    attr_reader :data, :metadata, :event_type, :version

    def initialize(data:, metadata:, event_type:, version:)
      @data = data
      @metadata = metadata
      @event_type = event_type
      @version = version
    end
  end
end
