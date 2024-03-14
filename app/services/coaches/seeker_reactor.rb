module Coaches
  class SeekerReactor < MessageConsumer
    def reset_for_replay; end

    def add_lead(lead_captured_by:, lead_id:, phone_number:, first_name:, last_name:, email: nil, now: Time.zone.now) # rubocop:disable Metrics/ParameterLists
      event_service.create!(
        event_schema: Events::LeadAdded::V2,
        context_id: lead_id,
        data: Events::LeadAdded::Data::V1.new(
          email:,
          lead_id:,
          phone_number:,
          first_name:,
          last_name:,
          lead_captured_by:
        ),
        occurred_at: now
      )
    end

    def add_note(context_id:, originator:, note:, note_id:, now: Time.zone.now)
      event_service.create!(
        event_schema: Events::NoteAdded::V3,
        context_id:,
        data: Events::NoteAdded::Data::V2.new(
          originator:,
          note:,
          note_id:
        ),
        occurred_at: now
      )
    end

    def delete_note(context_id:, originator:, note_id:, now: Time.zone.now)
      event_service.create!(
        event_schema: Events::NoteDeleted::V3,
        context_id:,
        data: Events::NoteDeleted::Data::V2.new(
          originator:,
          note_id:
        ),
        occurred_at: now
      )
    end

    def modify_note(context_id:, originator:, note_id:, note:, now: Time.zone.now)
      event_service.create!(
        event_schema: Events::NoteModified::V3,
        context_id:,
        data: Events::NoteModified::Data::V2.new(
          originator: originator,
          note_id:,
          note:
        ),
        occurred_at: now
      )
    end

    def certify(seeker_id:, coach:, now: Time.zone.now)
      user = User.find(coach.user_id)

      event_service.create!(
        event_schema: Events::SeekerCertified::V1,
        seeker_id:,
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
      event_service.create!(
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
      event_service.create!(
        event_schema: Events::BarrierUpdated::V2,
        context_id:,
        data: Events::BarrierUpdated::Data::V1.new(
          barriers:
        ),
        occurred_at: now
      )
    end

    def assign_coach(context_id:, coach_id:, coach_email:, now: Time.zone.now)
      event_service.create!(
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
      event_service.create!(
        event_schema: Events::SkillLevelUpdated::V2,
        context_id:,
        data: Events::SkillLevelUpdated::Data::V1.new(
          skill_level:
        ),
        occurred_at: now
      )
    end

    on_message Commands::AddLead::V1 do |_message|
      add_note(
        context_id:,
        coach:,
        note:,
        note_id:,
        now: Time.zone.now
      )
    end

    on_message Commands::AddNote::V1 do |_message|
      puts "bro"
    end

    on_message Commands::AssignCoach::V1 do |_message|
      puts "bro"
    end
  end
end
