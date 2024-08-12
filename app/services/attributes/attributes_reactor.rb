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

      message_service.create_once_for_trace!(
        schema: Events::Created::V3,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          **message.data.to_h
        },
        metadata: message.metadata
      )
    end

    on_message Commands::Update::V1, :sync do |message|
      return failed(NON_UNIQUE, message) if message.data.set.length != Set.new(message.data.set).length

      attributed_created = Projectors::Streams::GetFirst.project(
        stream: message.stream,
        schema: Events::Created::V3
      )

      return failed(DOES_NOT_EXIST, message) if attributed_created.nil?
      return failed(UNAUTHORIZED, message) if attributed_created.data.machine_derived && message.metadata.requestor_type != Requestor::Kinds::SERVER

      message_service.create_once_for_trace!(
        schema: Events::Updated::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          **message.data.to_h
        },
        metadata: message.metadata
      )
    end

    on_message Commands::Delete::V1, :sync do |message|
      attributed_created = Projectors::Streams::GetFirst.project(
        stream: message.stream,
        schema: Events::Created::V3
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
  end
end
