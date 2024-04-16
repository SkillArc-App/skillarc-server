module Messages
  class Schema
    module Status
      ALL = [
        ACTIVE = "active".freeze,
        DEPRECATED = "deprecated".freeze,
        INACTIVE = "inactive".freeze
      ].freeze
    end

    include(ValueSemantics.for_attributes do
      data
      metadata
      version Integer
      status Either(*Status::ALL)
      message_type Either(*Messages::Types::ALL)
      aggregate SubClass.Of(Aggregate)
    end)

    def serialize
      {
        version:,
        message_type:
      }
    end

    def self.deserialize(hash)
      MessageService.get_schema(message_type: hash[:message_type], version: hash[:version])
    end

    def self.active(data:, metadata:, message_type:, version:, aggregate:)
      schema = new(data:, metadata:, message_type:, version:, aggregate:, status: Status::ACTIVE)
      MessageService.register(schema:)
      schema
    end

    def self.deprecated(data:, metadata:, message_type:, version:, aggregate:)
      schema = new(data:, metadata:, message_type:, version:, aggregate:, status: Status::DEPRECATED)
      MessageService.register(schema:)
      schema
    end

    def self.inactive(data:, metadata:, message_type:, version:, aggregate:)
      schema = new(data:, metadata:, message_type:, version:, aggregate:, status: Status::INACTIVE)
      MessageService.register(schema:)
      schema
    end

    def all_messages
      MessageService.all_messages(self)
    end

    def active?
      status == Status::ACTIVE
    end

    def deprecated?
      status == Status::DEPRECATED
    end

    def inactive?
      status == Status::INACTIVE
    end

    def to_s
      "#<Messages::Schema message_type: #{message_type}, version: #{version}>"
    end

    private

    def initialize(data:, metadata:, message_type:, version:, aggregate:, status:) # rubocop:disable Metrics/ParameterLists
      super(data:, metadata:, message_type:, version:, aggregate:, status:)
    end
  end
end
