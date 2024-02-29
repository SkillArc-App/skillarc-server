module Coaches
  class SeekerService < EventConsumer # rubocop:disable Metrics/ClassLength
    def handled_events_sync
      [
        Events::BarrierUpdated::V1,
        Events::CoachAssigned::V1,
        Events::JobRecommended::V1,
        Events::SeekerCertified::V1,
        Events::LeadAdded::V1,
        Events::NoteAdded::V1,
        Events::NoteDeleted::V1,
        Events::NoteModified::V1
      ].freeze
    end

    def handled_events
      [
        Events::SkillLevelUpdated::V1,
        Events::ApplicantStatusUpdated::V5,
        Events::SeekerCreated::V1,
        Events::UserCreated::V1,
        Events::UserUpdated::V1,
        Events::EducationExperienceCreated::V1,
        Events::JobSaved::V1,
        Events::JobUnsaved::V1,
        Events::SeekerUpdated::V1,
        Events::OnboardingCompleted::V1,
        Events::JobSearch::V2
      ].freeze
    end

    def call(message:)
      handle_message(message)
    end

    def handle_message(message, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
      case message.event_schema

      # Coach Originated
      when Events::BarrierUpdated::V1
        handle_barriers_updated(message)
      when Events::CoachAssigned::V1
        handle_coach_assigned(message)

      when Events::JobRecommended::V1
        handle_job_recommended(message)

      when Events::SeekerCertified::V1
        handle_certify(message)

      when Events::LeadAdded::V1
        handle_lead_added(message)

      when Events::NoteAdded::V1
        handle_note_added(message)

      when Events::NoteDeleted::V1
        handle_note_deleted(message)

      when Events::NoteModified::V1
        handle_note_modified(message)

      when Events::SkillLevelUpdated::V1
        handle_skill_level_updated(message)

      # Multi Origin
      when Events::ApplicantStatusUpdated::V5
        handle_applicant_status_updated(message)

      # Seeker Originated
      when Events::SeekerCreated::V1
        handle_seeker_created(message)

      when Events::UserCreated::V1
        handle_user_created(message)

      when Events::UserUpdated::V1
        handle_user_updated(message)

      when Events::EducationExperienceCreated::V1,
        Events::JobSaved::V1,
        Events::JobUnsaved::V1,
        Events::PersonalExperienceCreated::V1,
        Events::OnboardingCompleted::V1
        handle_last_active_updated(message)
      when Events::SeekerUpdated::V1
        handle_seeker_updated(message)

      when Events::JobSearch::V2
        handle_last_active_updated(message) if Uuid === message.aggregate_id # rubocop:disable Style/CaseEquality
      end
    end

    def reset_for_replay
      SeekerLead.destroy_all
      SeekerNote.destroy_all
      SeekerApplication.destroy_all
      SeekerJobRecommendation.destroy_all
      SeekerBarrier.destroy_all
      CoachSeekerContext.destroy_all
    end

    def all_leads
      CoachSeekerContext.leads.with_everything.map do |csc|
        serialize_seeker_lead(csc)
      end
    end

    def all_seekers
      CoachSeekerContext.seekers.with_everything.where.not(seeker_id: nil).where.not(email: nil).map do |csc|
        serialize_coach_seeker_context(csc)
      end
    end

    def find_context(id)
      csc = CoachSeekerContext.with_everything.find_by!(seeker_id: id)

      serialize_coach_seeker_context(csc)
    end

    def add_lead(coach:, lead_id:, phone_number:, first_name:, last_name:, email: nil, now: Time.zone.now) # rubocop:disable Metrics/ParameterLists
      EventService.create!(
        event_schema: Events::LeadAdded::V1,
        aggregate_id: coach.id,
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

    def add_note(id:, coach:, note:, note_id:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteAdded::V1,
        aggregate_id: id,
        data: Events::NoteAdded::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note:,
          note_id:
        ),
        occurred_at: now
      )
    end

    def delete_note(id:, coach:, note_id:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteDeleted::V1,
        aggregate_id: id,
        data: Events::NoteDeleted::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id:
        ),
        occurred_at: now
      )
    end

    def modify_note(id:, coach:, note_id:, note:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteModified::V1,
        aggregate_id: id,
        data: Events::NoteModified::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id:,
          note:
        ),
        occurred_at: now
      )
    end

    def certify(seeker_id:, coach:, now: Time.zone.now)
      user = User.find(coach.user_id)

      EventService.create!(
        event_schema: Events::SeekerCertified::V1,
        aggregate_id: seeker_id,
        data: Events::SeekerCertified::Data::V1.new(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          coach_first_name: user.first_name,
          coach_last_name: user.last_name
        ),
        occurred_at: now
      )
    end

    def recommend_job(seeker_id:, job_id:, coach:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::JobRecommended::V1,
        aggregate_id: seeker_id,
        data: Events::JobRecommended::Data::V1.new(
          coach_id: coach.coach_id,
          job_id:
        ),
        occurred_at: now
      )
    end

    def update_barriers(id:, barriers:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::BarrierUpdated::V1,
        aggregate_id: id,
        data: Events::BarrierUpdated::Data::V1.new(
          barriers:
        ),
        occurred_at: now
      )
    end

    def assign_coach(id, coach_id, coach_email, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::CoachAssigned::V1,
        aggregate_id: id,
        data: Events::CoachAssigned::Data::V1.new(
          coach_id:,
          email: coach_email
        ),
        occurred_at: now
      )
    end

    def update_skill_level(id, skill_level, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::SkillLevelUpdated::V1,
        aggregate_id: id,
        data: Events::SkillLevelUpdated::Data::V1.new(
          skill_level:
        ),
        occurred_at: now
      )
    end

    private

    def handle_applicant_status_updated(message)
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

    def handle_barriers_updated(message)
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      csc.seeker_barriers.destroy_all
      message.data.barriers.each do |barrier|
        b = Barrier.find_by!(barrier_id: barrier)

        csc.seeker_barriers << SeekerBarrier.create!(
          coach_seeker_context: csc,
          barrier: b
        )
      end
    end

    def handle_coach_assigned(message)
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      csc.assigned_coach = message.data.coach_id
      csc.save!
    end

    def handle_job_recommended(message)
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      job_recommendation = Coaches::Job.find_by!(job_id: message.data.job_id)

      csc.seeker_job_recommendations << SeekerJobRecommendation.create!(
        coach_seeker_context: csc,
        coach_id: Coach.find_by!(coach_id: message.data.coach_id).id,
        job_id: job_recommendation.id
      )
    end

    def handle_certify(message)
      CoachSeekerContext.find_by!(seeker_id: message.aggregate_id).update!(
        certified_by: Coach.find_by!(coach_id: message.data.coach_id).email
      )
    end

    def handle_lead_added(message)
      return if message.data.email.present? && CoachSeekerContext.find_by(email: message.data.email)
      return if CoachSeekerContext.find_by(phone_number: message.data.phone_number)

      CoachSeekerContext.create!(
        email: message.data.email,
        phone_number: message.data.phone_number,
        lead_captured_by: message.data.lead_captured_by,
        lead_captured_at: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        kind: CoachSeekerContext::Kind::LEAD
      )
    end

    def handle_note_deleted(message)
      SeekerNote.find_by!(note_id: message.data.note_id).destroy
    end

    def handle_note_modified(message)
      SeekerNote.find_by!(note_id: message.data.note_id).update!(note: message.data.note)
    end

    def handle_note_added(message)
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      csc.update!(last_contacted_at: message.occurred_at)
      csc.seeker_notes << SeekerNote.create!(
        coach_seeker_context: csc,
        note_taken_at: message.occurred_at,
        note_taken_by: message.data.coach_email,
        note_id: message.data.note_id,
        note: message.data.note
      )
    end

    def handle_user_created(message)
      lead = CoachSeekerContext.find_by(email: message.data.email)
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
          email: message.data.email,
          first_name: message.data.first_name,
          last_name: message.data.last_name,
          last_active_on: message.occurred_at,
          kind: CoachSeekerContext::Kind::SEEKER
        )
      end
    end

    def handle_user_updated(message)
      csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        phone_number: message.data.phone_number
      )
    end

    def handle_seeker_created(message)
      csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at,
        seeker_id: message.data[:id]
      )
    end

    def handle_skill_level_updated(message)
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      csc.update!(
        skill_level: message.data.skill_level
      )
    end

    def handle_last_active_updated(message)
      csc = CoachSeekerContext.find_by!(user_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at
      )
    end

    def handle_seeker_updated(message)
      csc = CoachSeekerContext.find_by!(seeker_id: message.aggregate_id)

      csc.update!(
        last_active_on: message.occurred_at
      )
    end

    def serialize_coach_seeker_context(csc)
      {
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
        stage: 'seeker_created',
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
        email: csc.email,
        phone_number: csc.phone_number,
        first_name: csc.first_name,
        last_name: csc.last_name,
        lead_captured_at: csc.lead_captured_at,
        lead_captured_by: csc.lead_captured_by,
        status: SeekerLead::StatusTypes::NEW
      }
    end
  end
end
