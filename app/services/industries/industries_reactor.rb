module Industries
  class IndustriesReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::SetIndustries::V1 do |message|
      message_service.create_once_for_trace!(
        stream: message.stream,
        trace_id: message.trace_id,
        schema: Events::IndustriesSet::V1,
        data: {
          industries: message.data.industries
        }
      )
    end

    on_message Industries::Events::IndustriesSet::V1 do |message|
      if Projectors::Streams::HasOccurred.project(
        stream: Attributes::INDUSTRIES_STREAM,
        schema: Attributes::Events::Created::V3
      )
        message_service.create_once_for_trace!(
          schema: Attributes::Commands::Update::V1,
          trace_id: message.trace_id,
          stream: Attributes::INDUSTRIES_STREAM,
          data: {
            name: INDUSTRIES_NAME,
            description: "",
            set: message.data.industries,
            default: []
          },
          metadata: {
            requestor_type: Requestor::Kinds::SERVER,
            requestor_id: nil
          }
        )
      else
        message_service.create_once_for_trace!(
          schema: Attributes::Commands::Create::V1,
          trace_id: message.trace_id,
          stream: Attributes::INDUSTRIES_STREAM,
          data: {
            machine_derived: true,
            name: INDUSTRIES_NAME,
            description: "",
            set: message.data.industries,
            default: []
          },
          metadata: {
            requestor_type: Requestor::Kinds::SERVER,
            requestor_id: nil
          }
        )
      end
    end
  end
end
