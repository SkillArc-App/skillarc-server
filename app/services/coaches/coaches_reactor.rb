module Coaches
  class CoachesReactor < MessageReactor # rubocop:disable Metrics/ClassLength
    def add_attribute(person_id:, seeker_attribute_id:, attribute_id:, attribute_name:, attribute_values:, trace_id:) # rubocop:disable Metrics/ParameterLists
      message_service.create!(
        schema: Events::PersonAttributeAdded::V1,
        person_id:,
        trace_id:,
        data: {
          id: seeker_attribute_id,
          attribute_id:,
          attribute_name:,
          attribute_values:
        }
      )
    end

    def recommend_for_job_order(seeker_id:, job_order_id:, trace_id:)
      message_service.create!(
        schema: Events::JobOrderCandidateAdded::V1,
        job_order_id:,
        trace_id:,
        data: {
          seeker_id:
        }
      )
    end

    def remove_attribute(person_id:, seeker_attribute_id:, trace_id:)
      message_service.create!(
        schema: Events::PersonAttributeRemoved::V1,
        person_id:,
        trace_id:,
        data: {
          id: seeker_attribute_id
        }
      )
    end

    def add_note(person_id:, originator:, note:, note_id:, trace_id:)
      message_service.create!(
        schema: Events::NoteAdded::V4,
        person_id:,
        trace_id:,
        data: {
          originator:,
          note:,
          note_id:
        }
      )
    end

    def delete_note(person_id:, originator:, note_id:, trace_id:)
      message_service.create!(
        schema: Events::NoteDeleted::V4,
        person_id:,
        trace_id:,
        data: {
          originator:,
          note_id:
        }
      )
    end

    def modify_note(person_id:, originator:, note_id:, note:, trace_id:)
      message_service.create!(
        schema: Events::NoteModified::V4,
        person_id:,
        trace_id:,
        data: {
          originator:,
          note_id:,
          note:
        }
      )
    end

    def certify(person_id:, coach:, trace_id:)
      user = User.find(coach.user_id)

      message_service.create!(
        schema: Events::PersonCertified::V1,
        person_id:,
        trace_id:,
        data: {
          coach_id: coach.coach_id,
          coach_email: coach.email,
          coach_first_name: user.first_name,
          coach_last_name: user.last_name
        }
      )
    end

    def recommend_job(person_id:, job_id:, coach:, trace_id:)
      message_service.create!(
        schema: Events::JobRecommended::V3,
        person_id:,
        trace_id:,
        data: {
          coach_id: coach.coach_id,
          job_id:
        }
      )
    end

    def update_barriers(person_id:, barriers:, trace_id:)
      message_service.create!(
        schema: Events::BarrierUpdated::V3,
        person_id:,
        trace_id:,
        data: {
          barriers:
        }
      )
    end

    def assign_coach(person_id:, coach_id:, trace_id:)
      message_service.create!(
        schema: Events::CoachAssigned::V3,
        person_id:,
        trace_id:,
        data: {
          coach_id:
        }
      )
    end

    def update_skill_level(person_id:, skill_level:, trace_id:)
      message_service.create!(
        schema: Events::SkillLevelUpdated::V3,
        person_id:,
        trace_id:,
        data: {
          skill_level:
        }
      )
    end

    def create_reminder(coach:, note:, reminder_at:, trace_id:, person_id: nil)
      message_task_id = SecureRandom.uuid

      message_service.create!(
        schema: Events::CoachReminderScheduled::V2,
        coach_id: coach.coach_id,
        trace_id:,
        data: {
          reminder_id: SecureRandom.uuid,
          person_id:,
          note:,
          message_task_id:,
          reminder_at:
        }
      )

      message_service.create!(
        schema: Commands::ScheduleTask::V1,
        task_id: message_task_id,
        trace_id:,
        data: {
          execute_at: reminder_at - 1.hour,
          command: message_service.build(
            schema: Commands::SendMessage::V1,
            trace_id:,
            message_id: SecureRandom.uuid,
            data: {
              user_id: coach.user_id,
              title: "Reminder",
              body: "At #{reminder_at.to_fs(:long)}: #{note}",
              url: person_id && "#{ENV.fetch('FRONTEND_URL', nil)}/coaches/contexts/#{person_id}"
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

    on_message Commands::AssignCoach::V2 do |message|
      messages = MessageService.aggregate_events(message.aggregate)

      person_added = Projectors::Aggregates::HasOccurred.new(schema: Events::PersonAdded::V1)
      return unless person_added.project(messages)

      message_service.create_once_for_trace!(
        schema: Events::CoachAssigned::V3,
        aggregate: message.aggregate,
        data: {
          coach_id: message.data.coach_id
        }
      )
    end

    on_message Events::CoachReminderCompleted::V1 do |message|
      reminder = MessageService
                 .aggregate_events(message.aggregate)
                 .detect { |m| m.schema == Events::CoachReminderScheduled::V2 && message.data.reminder_id == m.data.reminder_id }

      return if reminder.nil?

      message_service.create_once_for_trace!(
        schema: Commands::CancelTask::V1,
        trace_id: message.trace_id,
        task_id: reminder.data.message_task_id,
        data: Messages::Nothing,
        metadata: {
          requestor_type: Requestor::Kinds::COACH,
          requestor_id: message.aggregate.id
        }
      )
    end

    on_message Events::JobRecommended::V3 do |message|
      job_id = message.data.job_id
      person_associated_to_user = Projectors::Aggregates::GetFirst.project(
        schema: Events::PersonAssociatedToUser::V1,
        aggregate: message.aggregate
      )

      return if person_associated_to_user.blank?

      message_service.create_once_for_trace!(
        schema: Commands::SendMessage::V1,
        message_id: SecureRandom.uuid,
        trace_id: message.trace_id,
        data: {
          user_id: person_associated_to_user.data.user_id,
          title: "From your SkillArc career coach",
          body: "Check out this job",
          url: "#{ENV.fetch('FRONTEND_URL', nil)}/jobs/#{job_id}"
        },
        metadata: {
          requestor_type: Requestor::Kinds::COACH,
          requestor_id: message.data.coach_id
        }
      )
    end
  end
end
