module Messages
  class Schema
    include(ValueSemantics.for_attributes do
      data
      metadata
      version Integer
      message_type Either(*Messages::Types::ALL)
      aggregate SubClass.Of(Aggregate)
    end)

    def self.build(data:, metadata:, message_type:, version:, aggregate:)
      message_schema = new(data:, metadata:, message_type:, version:, aggregate:)
      MessageService.register(message_schema:)
      message_schema
    end

    def all_messages
      MessageService.all_messages(self)
    end

    private

    def initialize(data:, metadata:, message_type:, version:, aggregate:)
      super(data:, metadata:, message_type:, version:, aggregate:)
    end
  end
end
