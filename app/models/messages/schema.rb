module Messages
  class Schema
    include(ValueSemantics.for_attributes do
      data
      metadata
      version Integer
      active Bool()
      message_type Either(*Messages::Types::ALL)
      aggregate SubClass.Of(Aggregate)
    end)

    def self.active(data:, metadata:, message_type:, version:, aggregate:)
      message_schema = new(data:, metadata:, message_type:, version:, aggregate:, active: true)
      MessageService.register(message_schema:)
      message_schema
    end

    def self.deprecated(data:, metadata:, message_type:, version:, aggregate:)
      message_schema = new(data:, metadata:, message_type:, version:, aggregate:, active: false)
      MessageService.register(message_schema:)
      message_schema
    end

    def all_messages
      MessageService.all_messages(self)
    end

    private

    def initialize(data:, metadata:, message_type:, version:, aggregate:, active:) # rubocop:disable Metrics/ParameterLists
      super(data:, metadata:, message_type:, version:, aggregate:, active:)
    end
  end
end
