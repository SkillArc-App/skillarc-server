module People
  class OnboardingReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Events::PersonAssociatedToUser::V1 do |message|
      message_service.create_once_for_trace!(
        schema: Commands::StartOnboarding::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: Core::Nothing
      )
    end

    on_message Commands::StartOnboarding::V2 do |message|
      message_service.create_once_for_stream!(
        schema: Events::OnboardingStarted::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: Core::Nothing
      )
    end

    on_message Commands::CompleteOnboarding::V2, :sync do |message|
      message_service.create_once_for_stream!(
        schema: Events::OnboardingCompleted::V3,
        trace_id: message.trace_id,
        stream: message.stream,
        data: Core::Nothing
      )
    end

    on_message Events::OnboardingCompleted::V3 do |message|
      messages = message_service.query.by_stream(message.stream).fetch
      email = Projectors::Email.new.project(messages).current_email

      message_service.create_once_for_stream!(
        trace_id: message.trace_id,
        schema: ::Commands::SendSlackMessage::V2,
        message_id: message.deterministic_uuid,
        data: {
          channel: "#feed",
          text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{message.stream.id}|#{email}> has completed onboarding"
        }
      )
    end

    on_message Events::OnboardingStarted::V2 do |message|
      messages = emit_complete_onboarding_if_applicable(message)
      email = Projectors::Email.new.project(messages).current_email

      return if email.blank?

      message_service.create_once_for_stream!(
        trace_id: message.trace_id,
        schema: ::Commands::SendSlackMessage::V2,
        message_id: message.deterministic_uuid,
        data: {
          channel: "#feed",
          text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{message.stream.id}|#{email}> has started onboarding"
        }
      )
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::ReliabilityAdded::V2 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::ExperienceAdded::V2 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::EducationExperienceAdded::V2 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::PersonTrainingProviderAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::ProfessionalInterestsAdded::V2 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    private

    def emit_complete_onboarding_if_applicable(message)
      messages = message_service.query.by_stream(message.stream).fetch

      return messages if ::Projectors::HasOccurred.new(schema: Events::OnboardingCompleted::V3).project(messages)

      status = Projectors::OnboardingStatus.new.project(messages)
      return messages unless status.next_step == Onboarding::Steps::COMPLETE_LOADING

      message_service.create_once_for_stream!(
        schema: Commands::CompleteOnboarding::V2,
        stream: message.stream,
        trace_id: message.trace_id,
        data: Core::Nothing
      )

      messages
    end
  end
end
