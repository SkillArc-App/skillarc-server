module Messages
  class Schema
    attr_reader :data, :metadata, :message_type, :version

    def self.build(data:, metadata:, message_type:, version:)
      message_schema = new(data:, metadata:, message_type:, version:)
      MessageService.register(message_schema:)
      message_schema
    end

    private

    def initialize(data:, metadata:, message_type:, version:)
      @data = data
      @metadata = metadata
      @message_type = message_type
      @version = version
    end
  end
end
