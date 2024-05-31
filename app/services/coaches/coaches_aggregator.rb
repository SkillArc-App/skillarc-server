module Coaches
  class CoachesAggregator < MessageConsumer # rubocop:disable Metrics/ClassLength
    def reset_for_replay
      SeekerNote.delete_all
      SeekerApplication.delete_all
      SeekerJobRecommendation.delete_all
      SeekerBarrier.delete_all
      Reminder.delete_all
      Coaches::SeekerAttribute.delete_all
      CoachSeekerContext.delete_all
      Barrier.delete_all
      Coach.delete_all
      Job.delete_all
      FeedEvent.delete_all
    end

    on_message Events::BarrierAdded::V1, :sync do |message|
      Barrier.create!(
        barrier_id: message.data.barrier_id,
        name: message.data.name
      )
    end

    on_message Events::CoachAdded::V1, :sync do |message|
      Coach.create!(
        coach_id: message.data.coach_id,
        user_id: message.aggregate.id,
        email: message.data.email,
        assignment_weight: 0
      )
    end

    on_message Events::CoachAssignmentWeightAdded::V1 do |message|
      coach = Coach.find_by!(coach_id: message.aggregate.id)
      coach.update!(assignment_weight: message.data.weight)
    end

    on_message Events::CoachReminderScheduled::V2, :sync do |message|
      coach = Coach.find_by!(coach_id: message.aggregate.coach_id)

      Reminder.create!(
        id: message.data.reminder_id,
        coach:,
        person_id: message.data.person_id,
        note: message.data.note,
        state: ReminderState::SET,
        message_task_id: message.data.message_task_id,
        reminder_at: message.data.reminder_at
      )
    end

    on_message Events::CoachReminderCompleted::V1, :sync do |message|
      reminder = Reminder.find(message.data.reminder_id)

      reminder.update!(
        state: ReminderState::COMPLETE
      )
    end

    on_message Events::PersonAttributeAdded::V1, :sync do |message|
      csc = Coaches::CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)
      seeker_attribute = SeekerAttribute.find_or_initialize_by(id: message.data.attribute_id)

      seeker_attribute.update!(
        coach_seeker_context_id: csc.id,
        attribute_name: message.data.attribute_name,
        attribute_values: message.data.attribute_values,
        attribute_id: message.data.attribute_id
      )
    end

    on_message Events::PersonAttributeRemoved::V1, :sync do |message|
      SeekerAttribute.find(message.data.id).destroy!
    end

    on_message Events::JobCreated::V3 do |message|
      Job.create!(
        job_id: message.aggregate_id,
        employment_title: message.data.employment_title,
        employer_name: message.data.employer_name,
        hide_job: message.data.hide_job
      )
    end

    on_message Events::JobUpdated::V2 do |message|
      job = Job.find_by!(job_id: message.aggregate_id)

      job.update!(
        employment_title: message.data.employment_title,
        hide_job: message.data.hide_job
      )
    end

    on_message Events::ApplicantStatusUpdated::V6 do |message|
      data = message.data
      csc = CoachSeekerContext.find_by!(seeker_id: data.seeker_id)

      first_name = data.applicant_first_name
      last_name = data.applicant_last_name
      email = data.applicant_email
      status = data.status

      application = SeekerApplication.find_or_create_by(
        coach_seeker_context: csc,
        application_id: message.aggregate.id
      )

      application.update!(
        status: data.status,
        employer_name: data.employer_name,
        job_id: data.job_id,
        employment_title: data.employment_title
      )

      FeedEvent.create!(
        context_id: csc.context_id,
        occurred_at: message.occurred_at,
        seeker_email: email,
        description:
          "#{first_name} #{last_name}'s application for #{data.employment_title} at #{data.employer_name} has been updated to #{status}."
      )
    end

    on_message Events::BarrierUpdated::V3, :sync do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)

      csc.seeker_barriers.destroy_all
      message.data.barriers.each do |barrier|
        b = Barrier.find_by!(barrier_id: barrier)

        csc.seeker_barriers << SeekerBarrier.create!(
          coach_seeker_context: csc,
          barrier: b
        )
      end
    end

    on_message Events::CoachAssigned::V3, :sync do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)
      coach = Coach.find_by(coach_id: message.data.coach_id)

      csc.update!(assigned_coach: coach.email)
    end

    on_message Events::JobRecommended::V3, :sync do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)

      job_recommendation = Coaches::Job.find_by!(job_id: message.data.job_id)

      csc.seeker_job_recommendations << SeekerJobRecommendation.create!(
        coach_seeker_context: csc,
        coach_id: Coach.find_by!(coach_id: message.data.coach_id).id,
        job_id: job_recommendation.id
      )
    end

    on_message Events::PersonCertified::V1, :sync do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)
      csc.update!(certified_by: Coach.find_by!(coach_id: message.data.coach_id).email)
    end

    on_message Events::NoteDeleted::V4, :sync do |message|
      SeekerNote.find_by!(note_id: message.data.note_id).destroy
    end

    on_message Events::NoteModified::V4, :sync do |message|
      SeekerNote.find_by!(note_id: message.data.note_id).update!(note: message.data.note)
    end

    on_message Events::NoteAdded::V4, :sync do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)
      csc.update!(last_contacted_at: message.occurred_at)

      csc.seeker_notes << SeekerNote.create!(
        coach_seeker_context: csc,
        note_taken_at: message.occurred_at,
        note_taken_by: message.data.originator,
        note_id: message.data.note_id,
        note: message.data.note
      )
    end

    on_message Events::BasicInfoAdded::V1 do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)

      csc.update!(
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number,
        email: message.data.email
      )
    end

    on_message Events::PersonAdded::V1 do |message|
      CoachSeekerContext.create!(
        seeker_id: message.aggregate_id,
        context_id: message.aggregate_id,
        email: message.data.email,
        phone_number: message.data.phone_number,
        seeker_captured_at: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        last_active_on: message.occurred_at,
        kind: CoachSeekerContext::Kind::LEAD
      )
    end

    on_message Events::PersonSourced::V1 do |message|
      return if message.data.source_kind != People::SourceKind::COACH

      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)
      coach = Coach.find_by!(coach_id: message.data.source_identifier)

      csc.update!(
        lead_captured_by: coach.email
      )
    end

    on_message Events::PersonAssociatedToUser::V1 do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.id)

      csc.update!(
        user_id: message.data.user_id,
        kind: CoachSeekerContext::Kind::SEEKER
      )
    end

    on_message Events::SessionStarted::V1 do |message|
      csc = CoachSeekerContext.find_by(user_id: message.aggregate.id)
      return if csc.nil?

      csc.update!(last_active_on: message.occurred_at)
    end

    on_message Events::SkillLevelUpdated::V3, :sync do |message|
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate.person_id)

      csc.update!(skill_level: message.data.skill_level)
    end
  end
end
