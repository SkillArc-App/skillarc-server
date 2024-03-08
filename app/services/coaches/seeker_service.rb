module Coaches
  class SeekerService < MessageConsumer # rubocop:disable Metrics/ClassLength
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

    def add_lead(coach:, lead_id:, phone_number:, first_name:, last_name:, email: nil, now: Time.zone.now) # rubocop:disable Metrics/ParameterLists
      EventService.create!(
        event_schema: Events::LeadAdded::V1,
        coach_id: coach.id,
        data: Events::LeadAdded::Data::V1.new(
          email:,
          lead_id:,
          phone_number:,
          first_name:,
          last_name:,
          lead_captured_by: coach.email
        ),
        occurred_at: now
      )
    end

    def add_note(context_id:, coach:, note:, note_id:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteAdded::V2,
        context_id:,
        data: Events::NoteAdded::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note:,
          note_id:
        ),
        occurred_at: now
      )
    end

    def delete_note(context_id:, coach:, note_id:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteDeleted::V2,
        context_id:,
        data: Events::NoteDeleted::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id:
        ),
        occurred_at: now
      )
    end

    def modify_note(context_id:, coach:, note_id:, note:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteModified::V2,
        context_id:,
        data: Events::NoteModified::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id:,
          note:
        ),
        occurred_at: now
      )
    end

    def certify(context_id:, coach:, now: Time.zone.now)
      user = User.find(coach.user_id)

      EventService.create!(
        event_schema: Events::SeekerCertified::V1,
        seeker_id: CoachSeekerContext.find_by!(context_id:).seeker_id,
        data: Events::SeekerCertified::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          coach_first_name: user.first_name,
          coach_last_name: user.last_name
        ),
        occurred_at: now
      )
    end

    def recommend_job(context_id:, job_id:, coach:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::JobRecommended::V2,
        context_id:,
        data: Events::JobRecommended::Data::V1.new(
          coach_id: coach.coach_id,
          job_id:
        ),
        occurred_at: now
      )
    end

    def update_barriers(context_id:, barriers:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::BarrierUpdated::V2,
        context_id:,
        data: Events::BarrierUpdated::Data::V1.new(
          barriers:
        ),
        occurred_at: now
      )
    end

    def assign_coach(context_id:, coach_id:, coach_email:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::CoachAssigned::V2,
        context_id:,
        data: Events::CoachAssigned::Data::V1.new(
          coach_id:,
          email: coach_email
        ),
        occurred_at: now
      )
    end

    def update_skill_level(context_id:, skill_level:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::SkillLevelUpdated::V2,
        context_id:,
        data: Events::SkillLevelUpdated::Data::V1.new(
          skill_level:
        ),
        occurred_at: now
      )
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

    on_message Events::LeadAdded::V1, :sync do |message|
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

    on_message Events::NoteDeleted::V2, :sync do |message|
      SeekerNote.find_by!(note_id: message.data.note_id).destroy
    end

    on_message Events::NoteModified::V2, :sync do |message|
      SeekerNote.find_by!(note_id: message.data.note_id).update!(note: message.data.note)
    end

    on_message Events::NoteAdded::V2, :sync do |message|
      csc = CoachSeekerContext.find_by!(context_id: message.aggregate.context_id)

      csc.update!(last_contacted_at: message.occurred_at)
      csc.seeker_notes << SeekerNote.create!(
        coach_seeker_context: csc,
        note_taken_at: message.occurred_at,
        note_taken_by: message.data.coach_email,
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
