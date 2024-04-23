module Coaches
  class CoachesAggregator < MessageConsumer # rubocop:disable Metrics/ClassLength
    def reset_for_replay
      SeekerNote.delete_all
      SeekerApplication.delete_all
      SeekerJobRecommendation.delete_all
      SeekerBarrier.delete_all
      Reminder.delete_all
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

    on_message Events::RoleAdded::V1, :sync do |message|
      return unless message.data.role == "coach"

      Coach.create!(
        coach_id: message.data.coach_id,
        user_id: message.aggregate_id,
        email: message.data.email
      )
    end

    on_message Events::CoachReminderScheduled::V1, :sync do |message|
      coach = Coach.find_by!(coach_id: message.aggregate.coach_id)

      Reminder.create!(
        id: message.data.reminder_id,
        coach:,
        context_id: message.data.context_id,
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
      csc = CoachSeekerContext.find_by!(user_id: data.user_id)
      csc.update!(last_active_on: message.occurred_at)

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

    on_message Events::BarrierUpdated::V2, :sync do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      csc.seeker_barriers.destroy_all
      message.data.barriers.each do |barrier|
        b = Barrier.find_by!(barrier_id: barrier)

        csc.seeker_barriers << SeekerBarrier.create!(
          coach_seeker_context: csc,
          barrier: b
        )
      end
    end

    on_message Events::CoachAssigned::V2, :sync do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      csc.assigned_coach = message.data.email
      csc.save!
    end

    on_message Events::JobRecommended::V2, :sync do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      job_recommendation = Coaches::Job.find_by!(job_id: message.data.job_id)

      csc.seeker_job_recommendations << SeekerJobRecommendation.create!(
        coach_seeker_context: csc,
        coach_id: Coach.find_by!(coach_id: message.data.coach_id).id,
        job_id: job_recommendation.id
      )
    end

    on_message Events::SeekerCertified::V1, :sync do |message|
      CoachSeekerContext.find_by!(seeker_id: message.aggregate_id).update!(
        certified_by: Coach.find_by!(coach_id: message.data.coach_id).email
      )
    end

    on_message Events::LeadAdded::V2, :sync do |message|
      return if message.data.email.present? && CoachSeekerContext.find_by(email: message.data.email)
      return if CoachSeekerContext.find_by(phone_number: message.data.phone_number)

      CoachSeekerContext.create!(
        email: message.data.email,
        context_id: message.data.lead_id,
        phone_number: message.data.phone_number,
        lead_captured_by: message.data.lead_captured_by,
        seeker_captured_at: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        lead_id: message.data.lead_id,
        kind: CoachSeekerContext::Kind::LEAD
      )
    end

    on_message Events::NoteDeleted::V3, :sync do |message|
      SeekerNote.find_by!(note_id: message.data.note_id).destroy
    end

    on_message Events::NoteModified::V3, :sync do |message|
      SeekerNote.find_by!(note_id: message.data.note_id).update!(note: message.data.note)
    end

    on_message Events::NoteAdded::V3, :sync do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      csc.update!(last_contacted_at: message.occurred_at)
      csc.seeker_notes << SeekerNote.create!(
        coach_seeker_context: csc,
        note_taken_at: message.occurred_at,
        note_taken_by: message.data.originator,
        note_id: message.data.note_id,
        note: message.data.note
      )
    end

    on_message Events::UserCreated::V1 do |message|
      lead = CoachSeekerContext.find_by(email: message.data.email) if message.data.email.present?

      if lead.present?
        lead.update!(
          user_id: message.aggregate_id,
          email: message.data.email,
          first_name: message.data.first_name,
          last_name: message.data.last_name,
          last_active_on: message.occurred_at,
          kind: CoachSeekerContext::Kind::SEEKER
        )
      else
        CoachSeekerContext.create!(
          user_id: message.aggregate_id,
          context_id: message.aggregate_id,
          email: message.data.email,
          seeker_captured_at: message.occurred_at,
          first_name: message.data.first_name,
          last_name: message.data.last_name,
          last_active_on: message.occurred_at,
          kind: CoachSeekerContext::Kind::SEEKER
        )
      end
    end

    on_message Events::UserUpdated::V1 do |message|
      csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number
      )
    end

    on_message Events::SeekerCreated::V1 do |message|
      csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at,
        seeker_id: message.data[:id]
      )
    end

    on_message Events::SkillLevelUpdated::V2, :sync do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      csc.update!(
        skill_level: message.data.skill_level
      )
    end

    on_message Events::EducationExperienceAdded::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::JobSaved::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::JobUnsaved::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::PersonalExperienceAdded::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::OnboardingCompleted::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::JobSearch::V2 do |message|
      return unless Uuid === message.aggregate_id # rubocop:disable Style/CaseEquality

      handle_last_active_updated(message)
    end

    on_message Events::SeekerUpdated::V1 do |message|
      handle_last_active_updated(message)

    end

    private

    def handle_last_active_updated(message)
      case message.aggregate
      when Aggregates::User, Aggregates::Search
        csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)
      when Aggregates::Seeker
        csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)
      end

      csc.update!(
        last_active_on: message.occurred_at
      )
    end
  end
end
