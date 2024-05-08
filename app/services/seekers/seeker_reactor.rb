module Seekers
  class SeekerReactor < MessageConsumer # rubocop:disable Metrics/ClassLength
    def reset_for_replay; end

    def add_education_experience(seeker_id:, organization_name:, title:, graduation_date:, gpa:, activities:, trace_id:, id: SecureRandom.uuid) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        schema: Events::EducationExperienceAdded::V1,
        seeker_id:,
        trace_id:,
        data: {
          id:,
          organization_name:,
          title:,
          graduation_date:,
          gpa:,
          activities:
        }
      )
    end

    def remove_education_experience(seeker_id:, education_experience_id:, trace_id:)
      message_service.create!(
        schema: Events::EducationExperienceDeleted::V1,
        trace_id:,
        seeker_id:,
        data: {
          id: education_experience_id
        }
      )
    end

    def add_personal_experience(seeker_id:, activity:, description:, start_date:, end_date:, trace_id:, id: SecureRandom.uuid) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        schema: Events::PersonalExperienceAdded::V1,
        seeker_id:,
        trace_id:,
        data: {
          id:,
          activity:,
          description:,
          start_date:,
          end_date:
        }
      )
    end

    def remove_personal_experience(seeker_id:, personal_experience_id:, trace_id:)
      message_service.create!(
        schema: Events::PersonalExperienceRemoved::V1,
        trace_id:,
        seeker_id:,
        data: {
          id: personal_experience_id
        }
      )
    end

    def add_experience(seeker_id:, organization_name:, position:, start_date:, end_date:, is_current:, description:, trace_id:, id: SecureRandom.uuid) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        schema: Events::ExperienceAdded::V1,
        trace_id:,
        seeker_id:,
        data: {
          id:,
          organization_name:,
          position:,
          start_date:,
          end_date:,
          description:,
          is_current:
        }
      )
    end

    def remove_experience(seeker_id:, experience_id:, trace_id:)
      message_service.create!(
        schema: Events::ExperienceRemoved::V1,
        trace_id:,
        seeker_id:,
        data: {
          id: experience_id
        }
      )
    end

    def add_seeker(user_id:, seeker_id:, trace_id:)
      message_service.create!(
        schema: Commands::AddSeeker::V1,
        trace_id:,
        user_id:,
        data: {
          id: seeker_id
        }
      )
    end

    def add_seeker_training_provider(seeker_id:, trace_id:, program_id:, training_provider_id:, status:, id: SecureRandom.uuid) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        seeker_id:,
        trace_id:,
        schema: Events::SeekerTrainingProviderCreated::V4,
        data: {
          id:,
          status:,
          program_id:,
          training_provider_id:
        }
      )
    end

    def add_reliability(seeker_id:, trace_id:, reliabilities:)
      message_service.create!(
        seeker_id:,
        trace_id:,
        schema: Events::ReliabilityAdded::V1,
        data: {
          reliabilities:
        }
      )
    end

    def add_professional_interests(seeker_id:, trace_id:, interests:)
      message_service.create!(
        seeker_id:,
        trace_id:,
        schema: Events::ProfessionalInterestsAdded::V1,
        data: {
          interests:
        }
      )
    end

    def add_basic_info(seeker_id:, user_id:, first_name:, last_name:, phone_number:, date_of_birth:, trace_id:) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        seeker_id:,
        trace_id:,
        schema: Events::BasicInfoAdded::V1,
        data: {
          user_id:,
          first_name:,
          last_name:,
          phone_number:,
          date_of_birth:
        }
      )
    end

    def complete_onboarding(seeker_id:, trace_id:)
      message_service.create!(
        seeker_id:,
        trace_id:,
        schema: Commands::CompleteOnboarding::V1,
        data: Messages::Nothing
      )
    end

    on_message Commands::AddSeeker::V1, :sync do |message|
      return if ::Projections::Aggregates::HasOccurred.project(aggregate: message.aggregate, schema: Events::SeekerCreated::V1)

      message_service.create!(
        schema: Events::SeekerCreated::V1,
        trace_id: message.trace_id,
        aggregate: message.aggregate,
        data: {
          id: message.data.id,
          user_id: message.aggregate.id
        }
      )
    end

    on_message Events::SeekerCreated::V1, :sync do |message|
      message_service.create!(
        schema: Commands::StartOnboarding::V1,
        trace_id: message.trace_id,
        seeker_id: message.data.id,
        data: {
          user_id: message.aggregate.id
        }
      )
    end

    on_message Commands::StartOnboarding::V1, :sync do |message|
      return if ::Projections::Aggregates::HasOccurred.project(aggregate: message.aggregate, schema: Events::OnboardingStarted::V1)

      message_service.create!(
        schema: Events::OnboardingStarted::V1,
        trace_id: message.trace_id,
        aggregate: message.aggregate,
        data: {
          user_id: message.data.user_id
        }
      )
    end

    on_message Commands::CompleteOnboarding::V1, :sync do |message|
      return if ::Projections::Aggregates::HasOccurred.project(aggregate: message.aggregate, schema: Events::OnboardingCompleted::V2)

      message_service.create!(
        schema: Events::OnboardingCompleted::V2,
        trace_id: message.trace_id,
        aggregate: message.aggregate,
        data: Messages::Nothing
      )
    end

    on_message Events::OnboardingStarted::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::ReliabilityAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::ExperienceAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::EducationExperienceAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::SeekerTrainingProviderCreated::V4 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    on_message Events::ProfessionalInterestsAdded::V1 do |message|
      emit_complete_onboarding_if_applicable(message)
    end

    private

    def emit_complete_onboarding_if_applicable(message)
      return if ::Projections::Aggregates::HasOccurred.project(aggregate: message.aggregate, schema: Events::OnboardingCompleted::V2)

      status = Seekers::Projections::OnboardingStatus.project(aggregate: message.aggregate)

      return unless status.next_step == Onboarding::Steps::COMPLETE

      message_service.create!(
        schema: Commands::CompleteOnboarding::V1,
        aggregate: message.aggregate,
        trace_id: message.trace_id,
        data: Messages::Nothing
      )
    end
  end
end
