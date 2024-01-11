class CoachSeekers
  def self.call(event:)
    self.handle_event(event)
  end

  def self.handle_event(event, with_side_effects: false, now: Time.now)
    case event.event_type
    when Event::EventTypes::COACH_ASSIGNED
      handle_coach_assigned(event)
    when Event::EventTypes::NOTE_ADDED
      handle_note_added(event)
    when Event::EventTypes::NOTE_DELETED
      handle_note_deleted(event)
    when Event::EventTypes::NOTE_MODIFIED
      handle_note_modified(event)
    when Event::EventTypes::PROFILE_CREATED
      handle_profile_created(event)
    when Event::EventTypes::SKILL_LEVEL_UPDATED
      handle_skill_level_updated(event)
    when Event::EventTypes::USER_CREATED
      handle_user_created(event)
    when Event::EventTypes::USER_UPDATED
      handle_user_updated(event)
    end
  end

  def self.all
    CoachSeekerContext.where.not(profile_id: nil).where.not(email: nil).map do |csc|
      serialize_coach_seeker_context(csc)
    end
  end

  def self.find(id)
    csc = CoachSeekerContext.find_by!(profile_id: id)

    serialize_coach_seeker_context(csc)
  end

  def self.add_note(id, note, note_id, now: Time.now)
    CreateEventJob.perform_later(
      event_type: Event::EventTypes::NOTE_ADDED,
      aggregate_id: id,
      data: {
        note:,
        note_id:
      },
      metadata: {},
      occurred_at: now
    )
  end

  def self.delete_note(id, note_id, now: Time.now)
    CreateEventJob.perform_later(
      event_type: Event::EventTypes::NOTE_DELETED,
      aggregate_id: id,
      data: {
        note_id:
      },
      metadata: {},
      occurred_at: now
    )
  end

  def self.modify_note(id, note_id, note, now: Time.now)
    CreateEventJob.perform_later(
      event_type: Event::EventTypes::NOTE_MODIFIED,
      aggregate_id: id,
      data: {
        note_id:,
        note:
      },
      metadata: {},
      occurred_at: now
    )
  end

  def self.assign_coach(id, coach_id, coach_email, now: Time.now)
    CreateEventJob.perform_later(
      event_type: Event::EventTypes::COACH_ASSIGNED,
      aggregate_id: id,
      data: {
        coach_id:,
        email: coach_email
      },
      metadata: {},
      occurred_at: now
    )
  end

  def self.update_skill_level(id, skill_level, now: Time.now)
    CreateEventJob.perform_later(
      event_type: Event::EventTypes::SKILL_LEVEL_UPDATED,
      aggregate_id: id,
      data: {
        skill_level:
      },
      metadata: {},
      occurred_at: now
    )
  end

  def self.handle_coach_assigned(event)
    csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

    csc.assigned_coach = event.data["coach_id"]
    csc.save!
  end

  def self.handle_note_deleted(event)
    SeekerNote.find_by!(note_id: event.data["note_id"]).destroy
  end

  def self.handle_note_modified(event)
    SeekerNote.find_by!(note_id: event.data["note_id"]).update!(note: event.data["note"])
  end

  def self.handle_note_added(event)
    csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

    csc.update!(last_contacted_at: [csc.last_contacted_at, event.occurred_at].compact.max)
    csc.seeker_notes << SeekerNote.create!(
      coach_seeker_context: csc,
      note_taken_at: event.occurred_at,
      note_id: event.data["note_id"],
      note: event.data["note"]
    )
  end

  def self.handle_user_created(event)
    user_id = event.aggregate_id

    csc = CoachSeekerContext.find_or_create_by(
      user_id:,
      email: event.data["email"],
      first_name: event.data["first_name"],
      last_name: event.data["last_name"],
      phone_number: event.data["phone_number"]
    )
    csc.last_active_on = event.occurred_at
    csc.save!
  end

  def self.handle_user_updated(event)
    csc = CoachSeekerContext.find_by!(user_id: event.aggregate_id)

    csc.update!(
      first_name: event.data["first_name"],
      last_name: event.data["last_name"],
      last_active_on: event.occurred_at,
      phone_number: event.data["phone_number"]
    )
  end

  def self.handle_profile_created(event)
    csc = CoachSeekerContext.find_by!(user_id: event.aggregate_id)

    csc.update!(
      last_active_on: event.occurred_at,
      profile_id: event.data["id"]
    )
  end

  def self.handle_skill_level_updated(event)
    csc = CoachSeekerContext.find_by!(profile_id: event.aggregate_id)

    csc.update!(
      skill_level: event.data["skill_level"]
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
      barriers: csc.barriers,
      stage: 'profile_created',
      notes: csc.seeker_notes.map do |note|
        {
          note: note.note,
          noteId: note.note_id,
          date: note.note_taken_at
        }
      end
    }
  end
end
