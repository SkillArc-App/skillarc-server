module Coaches
  class SeekerAggregator < MessageConsumer # rubocop:disable Metrics/ClassLength
    def reset_for_replay
      SeekerNote.delete_all
      SeekerApplication.delete_all
      SeekerJobRecommendation.delete_all
      SeekerBarrier.delete_all
      CoachSeekerContext.delete_all
    end

    def all_leads
      CoachSeekerContext.leads.with_everything.map do |csc|
        serialize_seeker_lead(csc)
      end
    end

    def all_seekers
      CoachSeekerContext.seekers.with_everything.map do |csc|
        serialize_coach_seeker_context(csc)
      end
    end

    def find_context(id)
      csc = CoachSeekerContext.find_by!(context_id: id)

      serialize_coach_seeker_context(csc)
    end

    on_message Events::ApplicantStatusUpdated::V5 do |message|
      csc = CoachSeekerContext.find_by!(user_id: message.data.user_id)
      csc.update!(last_active_on: message.occurred_at)

      application = SeekerApplication.find_or_create_by(
        coach_seeker_context: csc,
        application_id: message.data.applicant_id
      )

      application.update!(
        status: message.data.status,
        employer_name: message.data.employer_name,
        job_id: message.data.job_id,
        employment_title: message.data.employment_title
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
        lead_captured_at: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
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

    on_message Events::SkillLevelUpdated::V2 do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      csc.update!(
        skill_level: message.data.skill_level
      )
    end

    on_message Events::EducationExperienceCreated::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::JobSaved::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::JobUnsaved::V1 do |message|
      handle_last_active_updated(message)
    end

    on_message Events::PersonalExperienceCreated::V1 do |message|
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
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at
      )
    end

    private

    def handle_last_active_updated(message)
      csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at
      )
    end

    def serialize_coach_seeker_context(csc)
      {
        id: csc.context_id,
        kind: csc.kind,
        seeker_id: csc.seeker_id,
        first_name: csc.first_name,
        last_name: csc.last_name,
        email: csc.email,
        phone_number: csc.phone_number,
        certified_by: csc.certified_by,
        skill_level: csc.skill_level || 'beginner',
        last_active_on: csc.last_active_on,
        last_contacted: csc.last_contacted_at || "Never",
        assigned_coach: csc.assigned_coach || 'none',
        barriers: csc.seeker_barriers.map(&:barrier).map { |b| { id: b.barrier_id, name: b.name } },
        notes: csc.seeker_notes.map do |note|
          {
            note: note.note,
            note_id: note.note_id,
            note_taken_by: note.note_taken_by,
            date: note.note_taken_at
          }
        end,
        applications: csc.seeker_applications.map do |application|
          {
            status: application.status,
            employer_name: application.employer_name,
            job_id: application.job_id,
            employment_title: application.employment_title
          }
        end,
        job_recommendations: csc.seeker_job_recommendations.map(&:job).map(&:job_id)
      }
    end

    def serialize_seeker_lead(csc)
      {
        id: csc.context_id,
        email: csc.email,
        assigned_coach: csc.assigned_coach || 'none',
        phone_number: csc.phone_number,
        first_name: csc.first_name,
        last_name: csc.last_name,
        lead_captured_at: csc.lead_captured_at,
        lead_captured_by: csc.lead_captured_by,
        kind: csc.kind,
        status: "new"
      }
    end
  end
end
