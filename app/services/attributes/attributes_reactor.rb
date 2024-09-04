module Attributes
  class AttributesReactor < MessageReactor
    def can_replay?
      true
    end

    NON_UNIQUE = "attribute set is not unique".freeze
    DOES_NOT_EXIST = "attribute does not exist".freeze
    UNAUTHORIZED = "users cannot altered machined derived attributes".freeze

    on_message Commands::Create::V1, :sync do |message|
      return failed(NON_UNIQUE, message) if message.data.set.length != Set.new(message.data.set).length

      messages = message_service.query.by_stream(message.stream).before(message).fetch
      attributed_created = ::Projectors::Streams::GetFirst.new(schema: Events::Created::V4).project(messages)

      # TODO: we probably need to prevent updates after delete
      return failed(UNAUTHORIZED, message) if attributed_created&.data&.machine_derived && message.metadata.requestor_type != Requestor::Kinds::SERVER

      if attributed_created.present?
        message_service.create_once_for_trace!(
          schema: Events::Updated::V3,
          trace_id: message.trace_id,
          stream: message.stream,
          data: {
            name: message.data.name,
            description: message.data.description,
            set: message.data.set.map { |v| pick_kvp(attributed_created.data.set, v) },
            default: message.data.default.map { |v| pick_kvp(attributed_created.data.default, v) }
          },
          metadata: message.metadata
        )
      else
        # TODO: We shouldn't fundamentally need to do this once for stream as
        # we should be able to catch it above on GetFirst. investigate this hack
        message_service.create_once_for_stream!(
          schema: Events::Created::V4,
          trace_id: message.trace_id,
          stream: message.stream,
          data: {
            machine_derived: message.data.machine_derived,
            name: message.data.name,
            description: message.data.description,
            set: message.data.set.map { |value| Core::UuidKeyValuePair.new(key: SecureRandom.uuid, value:) },
            default: message.data.default.map { |value| Core::UuidKeyValuePair.new(key: SecureRandom.uuid, value:) }
          },
          metadata: message.metadata
        )
      end
    end

    on_message Commands::Delete::V1, :sync do |message|
      attributed_created = ::Projectors::Streams::GetFirst.project(
        stream: message.stream,
        schema: Events::Created::V4
      )
      return failed(DOES_NOT_EXIST, message) if attributed_created.nil?
      return failed(UNAUTHORIZED, message) if attributed_created.data.machine_derived && message.metadata.requestor_type != Requestor::Kinds::SERVER

      message_service.create_once_for_trace!(
        schema: Events::Deleted::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: Core::Nothing,
        metadata: message.metadata
      )
    end

    private

    def failed(reason, message)
      message_service.create_once_for_trace!(
        schema: Events::CommandFailed::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          reason:
        },
        metadata: message.metadata
      )
    end

    def pick_kvp(existing_values, value)
      existing_kvp = existing_values.detect { |kvp| kvp.value == value }
      return existing_kvp if existing_kvp.present?

      Core::UuidKeyValuePair.new(key: SecureRandom.uuid, value:)
    end
  end
end
