# frozen_string_literal: true

module Users
  module MessageTypes
    EVENTS = [
      BARRIER_ADDED = 'barrier_added',
      COACH_ADDED = 'coach_added',
      CONTACTED = 'contacted',
      PERSON_VIEWED = 'person_viewed',
      REASON_CREATED = 'reason_created',
      SESSION_STARTED = 'session_started',
      MET_CAREER_COACH_UPDATED = 'met_career_coach_updated',
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read',
      JOB_SAVED = 'job_saved',
      JOB_OWNER_ASSIGNED = 'job_owner_assigned',
      PERSON_SEARCH_EXECUTED = 'person_search_executed',
      JOB_SEARCH = 'job_search',
      JOB_UNSAVED = 'job_unsaved',
      PROFILE_CREATED = 'profile_created',
      ROLE_ADDED = 'role_added',
      SEEKER_VIEWED = 'seeker_viewed',
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
      EXPERIENCE_CREATED = 'experience_created',
      EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
      EDUCATION_EXPERIENCE_UPDATED = 'education_experience_updated',
      USER_CREATED = 'user_created',
      USER_UPDATED = 'user_updated'
    ].freeze

    COMMANDS = [
      SET_CONTACT_PREFERENCE = "set_contact_preference",
      CONTACT = 'contact'
    ].freeze
  end
end
