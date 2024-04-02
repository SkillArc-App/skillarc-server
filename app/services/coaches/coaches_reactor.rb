module Coaches
  class CoachesReactor < MessageConsumer
    def reset_for_replay; end

    def add_lead(lead_captured_by:, lead_id:, phone_number:, first_name:, last_name:, trace_id:, email: nil) # rubocop:disable Metrics/ParameterLists
      event_service.create!(
        event_schema: Events::LeadAdded::V2,
        context_id: lead_id,
        trace_id:,
        data: {
          email:,
          lead_id:,
          phone_number:,
          first_name:,
          last_name:,
          lead_captured_by:
        }
      )
    end

    def add_note(context_id:, originator:, note:, note_id:, trace_id:)
      event_service.create!(
        event_schema: Events::NoteAdded::V3,
        context_id:,
        trace_id:,
        data: {
          originator:,
          note:,
          note_id:
        }
      )
    end

    def delete_note(context_id:, originator:, note_id:, trace_id:)
      event_service.create!(
        event_schema: Events::NoteDeleted::V3,
        context_id:,
        trace_id:,
        data: {
          originator:,
          note_id:
        }
      )
    end

    def modify_note(context_id:, originator:, note_id:, note:, trace_id:)
      event_service.create!(
        event_schema: Events::NoteModified::V3,
        context_id:,
        trace_id:,
        data: {
          originator:,
          note_id:,
          note:
        }
      )
    end

    def certify(seeker_id:, coach:, trace_id:)
      user = User.find(coach.user_id)

      event_service.create!(
        event_schema: Events::SeekerCertified::V1,
        seeker_id:,
        trace_id:,
        data: {
          coach_id: coach.coach_id,
          coach_email: coach.email,
          coach_first_name: user.first_name,
          coach_last_name: user.last_name
        }
      )
    end

    def recommend_job(context_id:, job_id:, coach:, trace_id:)
      event_service.create!(
        event_schema: Events::JobRecommended::V2,
        context_id:,
        trace_id:,
        data: {
          coach_id: coach.coach_id,
          job_id:
        }
      )
    end

    def update_barriers(context_id:, barriers:, trace_id:)
      event_service.create!(
        event_schema: Events::BarrierUpdated::V2,
        context_id:,
        trace_id:,
        data: {
          barriers:
        }
      )
    end

    def assign_coach(context_id:, coach_id:, coach_email:, trace_id:)
      event_service.create!(
        event_schema: Events::CoachAssigned::V2,
        context_id:,
        trace_id:,
        data: {
          coach_id:,
          email: coach_email
        }
      )
    end

    def update_skill_level(context_id:, skill_level:, trace_id:)
      event_service.create!(
        event_schema: Events::SkillLevelUpdated::V2,
        context_id:,
        trace_id:,
        data: {
          skill_level:
        }
      )
    end

    on_message Commands::AddLead::V1 do |message|
      data = message.data
      add_lead(
        lead_captured_by: data.lead_captured_by,
        lead_id: data.lead_id,
        phone_number: data.phone_number,
        first_name: data.first_name,
        last_name: data.last_name,
        email: data.email,
        trace_id: message.trace_id
      )
    end

    on_message Commands::AddNote::V1 do |message|
      data = message.data

      add_note(
        context_id: message.aggregate.context_id,
        originator: data.originator,
        note: data.note,
        note_id: data.note_id,
        trace_id: message.trace_id
      )
    end

    on_message Commands::AssignCoach::V1 do |message|
      data = message.data

      coach = Coaches::Coach.find_by(email: data.coach_email)
      return if coach.blank?

      assign_coach(
        context_id: message.aggregate.context_id,
        coach_id: coach.coach_id,
        coach_email: data.coach_email,
        trace_id: message.trace_id
      )
    end

    on_message Events::LeadAdded::V2 do |message|
      command_service.create!(
        trace_id: message.trace_id,
        context_id: message.aggregate.context_id,
        command_schema: Commands::AssignCoach::V1,
        data: {
          coach_email: message.data.lead_captured_by
        }
      )
    end
  end
end
