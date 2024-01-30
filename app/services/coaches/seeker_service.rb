module Coaches
  class SeekerService # rubocop:disable Metrics/ClassLength
    def self.handled_events
      [
        Events::BarrierUpdated::V1,
        Events::CoachAssigned::V1,
        Events::LeadAdded::V1,
        Events::NoteAdded::V1,
        Events::NoteDeleted::V1,
        Events::NoteModified::V1,
        Events::SkillLevelUpdated::V1,
        Events::ApplicantStatusUpdated::V1,
        Events::SeekerCreated::V1,
        Events::UserCreated::V1,
        Events::UserUpdated::V1,
        Events::EducationExperienceCreated::V1,
        Events::JobSaved::V1,
        Events::JobUnsaved::V1,
        Events::SeekerUpdated::V1,
        Events::OnboardingCompleted::V1
      ].freeze
    end

    def self.call(event:)
      handle_event(event)
    end

    def self.handle_event(event, with_side_effects: false, now: Time.zone.now) # rubocop:disable Lint/UnusedMethodArgument
      case event.event_schema

      # Coach Originated
      when Events::BarrierUpdated::V1
        handle_barriers_updated(event)
      when Events::CoachAssigned::V1
        handle_coach_assigned(event)

      when Events::LeadAdded::V1
        handle_lead_added(event)

      when Events::NoteAdded::V1
        handle_note_added(event)

      when Events::NoteDeleted::V1
        handle_note_deleted(event)

      when Events::NoteModified::V1
        handle_note_modified(event)

      when Events::SkillLevelUpdated::V1
        handle_skill_level_updated(event)

      # Multi Origin
      when Events::ApplicantStatusUpdated::V1
        handle_applicant_status_updated(event)

      # Seeker Originated
      when Events::SeekerCreated::V1
        handle_profile_created(event)

      when Events::UserCreated::V1
        handle_user_created(event)

      when Events::UserUpdated::V1
        handle_user_updated(event)

      when Events::EducationExperienceCreated::V1,
        Events::JobSaved::V1,
        Events::JobUnsaved::V1,
        Events::PersonalExperienceCreated::V1,
        Events::SeekerUpdated::V1,
        Events::OnboardingCompleted::V1
        handle_last_active_updated(event)
      end
    end

    def self.all_leads
      SeekerLead.all.map do |seeker_lead|
        serialize_seeker_lead(seeker_lead)
      end
    end

    def self.all_contexts
      CoachSeekerContext.includes(:seeker_notes, :seeker_applications, :seeker_barriers).where.not(profile_id: nil).where.not(email: nil).map do |csc|
        serialize_coach_seeker_context(csc)
      end
    end

    def self.find_context(id)
      csc = CoachSeekerContext.includes(:seeker_notes, :seeker_applications, :seeker_barriers).find_by!(profile_id: id)

      serialize_coach_seeker_context(csc)
    end

    def self.add_lead(coach:, lead_id:, phone_number:, first_name:, last_name:, email: nil, now: Time.zone.now) # rubocop:disable Metrics/ParameterLists
      EventService.create!(
        event_schema: Events::LeadAdded::V1,
        aggregate_id: coach.id,
        data: Events::Common::UntypedHashWrapper.build(
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

    def self.add_note(id:, coach:, note:, note_id:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteAdded::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note:,
          note_id:
        ),
        occurred_at: now
      )
    end

    def self.delete_note(id:, coach:, note_id:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteDeleted::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id:
        ),
        occurred_at: now
      )
    end

    def self.modify_note(id:, coach:, note_id:, note:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::NoteModified::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id: coach.coach_id,
          coach_email: coach.email,
          note_id:,
          note:
        ),
        occurred_at: now
      )
    end

    def self.update_barriers(id:, barriers:, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::BarrierUpdated::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.build(
          barriers:
        ),
        occurred_at: now
      )
    end

    def self.assign_coach(id, coach_id, coach_email, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::CoachAssigned::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.build(
          coach_id:,
          email: coach_email
        ),
        occurred_at: now
      )
    end

    def self.update_skill_level(id, skill_level, now: Time.zone.now)
      EventService.create!(
        event_schema: Events::SkillLevelUpdated::V1,
        aggregate_id: id,
        data: Events::Common::UntypedHashWrapper.build(
          skill_level:
        ),
        occurred_at: now
      )
    end

    def self.handle_applicant_status_updated(event)
      csc = CoachSeekerContext.find_by!(user_id: event.data[:user_id])
      csc.update!(last_active_on: event.occurred_at)

      application = SeekerApplication.find_or_create_by(
        coach_seeker_context: csc,
        application_id: event.data[:application_id] || event.data[:applicant_id]
      )

      application.update!(
        status: event.data[:status],
        employer_name: event.data[:employer_name],
        job_id: event.data[:job_id],
        employment_title: event.data[:employment_title]
      )
    end

    def self.handle_barriers_updated(event)
      csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

      csc.seeker_barriers.destroy_all
      event.data[:barriers].each do |barrier|
        b = Barrier.find_by!(barrier_id: barrier)

        csc.seeker_barriers << SeekerBarrier.create!(
          coach_seeker_context: csc,
          barrier: b
        )
      end
    end

    def self.handle_coach_assigned(event)
      csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

      csc.assigned_coach = event.data[:coach_id]
      csc.save!
    end

    def self.handle_lead_added(event)
      SeekerLead.create!(
        lead_id: event.data[:lead_id],
        email: event.data[:email],
        phone_number: event.data[:phone_number],
        first_name: event.data[:first_name],
        last_name: event.data[:last_name],
        lead_captured_at: event.occurred_at,
        lead_captured_by: event.data[:lead_captured_by],
        status: SeekerLead::StatusTypes::NEW
      )
    end

    def self.handle_note_deleted(event)
      SeekerNote.find_by!(note_id: event.data[:note_id]).destroy
    end

    def self.handle_note_modified(event)
      SeekerNote.find_by!(note_id: event.data[:note_id]).update!(note: event.data[:note])
    end

    def self.handle_note_added(event)
      csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

      csc.update!(last_contacted_at: event.occurred_at)
      csc.seeker_notes << SeekerNote.create!(
        coach_seeker_context: csc,
        note_taken_at: event.occurred_at,
        note_taken_by: event.data[:coach_email],
        note_id: event.data[:note_id],
        note: event.data[:note]
      )
    end

    def self.handle_user_created(event)
      user_id = event.aggregate_id

      csc = CoachSeekerContext.find_or_create_by(
        user_id:,
        email: event.data[:email],
        first_name: event.data[:first_name],
        last_name: event.data[:last_name],
        phone_number: event.data[:phone_number]
      )
      csc.last_active_on = event.occurred_at
      csc.save!

      SeekerLead.where(email: event.data[:email])
                .or(SeekerLead.where(phone_number: event.data[:phone_number]))
                .update!(status: SeekerLead::StatusTypes::CONVERTED)
    end

    def self.handle_user_updated(event)
      csc = CoachSeekerContext.find_by!(user_id: event.aggregate_id)

      csc.update!(
        last_active_on: event.occurred_at,
        first_name: event.data[:first_name],
        last_name: event.data[:last_name],
        phone_number: event.data[:phone_number]
      )
    end

    def self.handle_profile_created(event)
      csc = CoachSeekerContext.find_by!(user_id: event.aggregate_id)

      csc.update!(
        last_active_on: event.occurred_at,
        profile_id: event.data[:id]
      )
    end

    def self.handle_skill_level_updated(event)
      csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

      csc.update!(
        skill_level: event.data[:skill_level]
      )
    end

    def self.handle_last_active_updated(event)
      csc = CoachSeekerContext.find_by!(user_id: event.aggregate_id)

      csc.update!(
        last_active_on: event.occurred_at
      )
    end

    def self.serialize_coach_seeker_context(csc)
      {
        seekerId: csc.profile_id,
        firstName: csc.first_name,
        lastName: csc.last_name,
        email: csc.email,
        phoneNumber: csc.phone_number,
        skillLevel: csc.skill_level || 'beginner',
        lastActiveOn: csc.last_active_on,
        lastContacted: csc.last_contacted_at || "Never",
        assignedCoach: csc.assigned_coach || 'none',
        barriers: csc.seeker_barriers.map(&:barrier).map { |b| { id: b.barrier_id, name: b.name } },
        stage: 'profile_created',
        notes: csc.seeker_notes.map do |note|
          {
            note: note.note,
            noteId: note.note_id,
            noteTakenBy: note.note_taken_by,
            date: note.note_taken_at
          }
        end,
        applications: csc.seeker_applications.map do |application|
          {
            status: application.status,
            employerName: application.employer_name,
            jobId: application.job_id,
            employmentTitle: application.employment_title
          }
        end
      }
    end

    def self.serialize_seeker_lead(seeker_lead)
      {
        email: seeker_lead.email,
        phone_number: seeker_lead.phone_number,
        first_name: seeker_lead.first_name,
        last_name: seeker_lead.last_name,
        lead_captured_at: seeker_lead.lead_captured_at,
        lead_captured_by: seeker_lead.lead_captured_by,
        status: seeker_lead.status
      }
    end
  end
end
