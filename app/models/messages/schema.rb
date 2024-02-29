module Messages
  class Schema
    include(ValueSemantics.for_attributes do
      data
      metadata
      version Integer
      message_type Either(*Messages::Types::ALL)
    end)

    def self.build(data:, metadata:, message_type:, version:)
      message_schema = new(data:, metadata:, message_type:, version:)
      MessageService.register(message_schema:)
      message_schema
    end

    private

    def initialize(data:, metadata:, message_type:, version:)
      super(data:, metadata:, message_type:, version:)
    end
  end
end
