module Seekers
  class SeekerReactor < MessageConsumer
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
  end
end
