module Seekers
  class SeekerReactor < MessageConsumer
    def reset_for_replay; end

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
