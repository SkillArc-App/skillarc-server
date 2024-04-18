module Coaches
  class CoachesReactor < MessageConsumer # rubocop:disable Metrics/ClassLength
    def reset_for_replay; end

    def add_lead(lead_captured_by:, lead_id:, phone_number:, first_name:, last_name:, trace_id:, email: nil) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        schema: Events::LeadAdded::V2,
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
      message_service.create!(
        schema: Events::NoteAdded::V3,
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
      message_service.create!(
        schema: Events::NoteDeleted::V3,
        context_id:,
        trace_id:,
        data: {
          originator:,
          note_id:
        }
      )
    end

    def modify_note(context_id:, originator:, note_id:, note:, trace_id:)
      message_service.create!(
        schema: Events::NoteModified::V3,
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

      message_service.create!(
        schema: Events::SeekerCertified::V1,
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
      message_service.create!(
        schema: Events::JobRecommended::V2,
        context_id:,
        trace_id:,
        data: {
          coach_id: coach.coach_id,
          job_id:
        }
      )
    end

    def update_barriers(context_id:, barriers:, trace_id:)
      message_service.create!(
        schema: Events::BarrierUpdated::V2,
        context_id:,
        trace_id:,
        data: {
          barriers:
        }
      )
    end

    def assign_coach(context_id:, coach_id:, coach_email:, trace_id:)
      message_service.create!(
        schema: Events::CoachAssigned::V2,
        context_id:,
        trace_id:,
        data: {
          coach_id:,
          email: coach_email
        }
      )
    end

    def update_skill_level(context_id:, skill_level:, trace_id:)
      message_service.create!(
        schema: Events::SkillLevelUpdated::V2,
        context_id:,
        trace_id:,
        data: {
          skill_level:
        }
      )
    end

    def create_reminder(coach:, note:, reminder_at:, trace_id:, context_id: nil)
      message_task_id = SecureRandom.uuid

      message_service.create!(
        schema: Events::CoachReminder::V1,
        coach_id: coach.coach_id,
        trace_id:,
        data: {
          reminder_id: SecureRandom.uuid,
          context_id:,
          note:,
          message_task_id:,
          reminder_at:
        }
      )

      message_service.create!(
        schema: Commands::ScheduleCommand::V1,
        task_id: message_task_id,
        trace_id:,
        data: {
          execute_at: reminder_at - 1.hour,
          message: message_service.build(
            schema: Commands::SendMessage::V1,
            trace_id:,
            message_id: SecureRandom.uuid,
            data: {
              user_id: coach.user_id,
              title: "Reminder",
              body: note,
              url: context_id && "#{ENV.fetch('FRONTEND_URL', nil)}/coaches/contexts/#{context_id}"
            },
            metadata: {
              requestor_type: Requestor::Kinds::USER,
              requestor_id: coach.user_id
            }
          )
        },
        metadata: {
          requestor_type: Requestor::Kinds::USER,
          requestor_id: coach.user_id
        }
      )
    end

    def complete_reminder(coach:, reminder_id:, trace_id:)
      message_service.create!(
        schema: Events::CoachReminderCompleted::V1,
        coach_id: coach.coach_id,
        trace_id:,
        data: {
          reminder_id:
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
      csc = Coaches::CoachSeekerContext.find_by(lead_id: message.aggregate.context_id)
      return if csc&.assigned_coach.present?

      coach = Coach.find_by(email: message.data.lead_captured_by)
      coach ||= CoachAssignmentService.round_robin_assignment

      message_service.create!(
        trace_id: message.trace_id,
        context_id: message.aggregate.context_id,
        schema: Commands::AssignCoach::V1,
        data: {
          coach_email: coach.email
        }
      )
    end

    on_message Events::UserCreated::V1 do |message|
      csc = Coaches::CoachSeekerContext.find_by(user_id: message.aggregate.user_id)
      return if csc&.assigned_coach.present?

      coach = CoachAssignmentService.round_robin_assignment

      message_service.create!(
        trace_id: message.trace_id,
        context_id: message.aggregate.user_id,
        schema: Commands::AssignCoach::V1,
        data: {
          coach_email: coach.email
        }
      )
    end

    on_message Events::JobRecommended::V2 do |message|
      job_id = message.data.job_id

      csc = CoachSeekerContext.find_by(context_id: message.aggregate_id)
      return if csc&.phone_number.nil?

      message_service.create!(
        schema: Commands::SendSmsMessage::V3,
        message_id: SecureRandom.uuid,
        trace_id: message.trace_id,
        data: {
          phone_number: csc.phone_number,
          message: "From your SkillArc career coach. Check out this job: #{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
        }
      )
    end
  end
end
