# frozen_string_literal: true

module People
  module MessageTypes
    EVENTS = [
      NOTE_ADDED = 'note_added',
      NOTE_DELETED = 'note_deleted',
      NOTE_MODIFIED = 'note_modified',
      COACH_ASSIGNED = 'coach_assigned',
      BARRIERS_UPDATED = 'barriers_updated',
      JOB_RECOMMENDED = 'job_recommended',
      BASIC_INFO_ADDED = 'basic_info_added',
      DATE_OF_BIRTH_ADDED = 'date_of_birth_added',
      EDUCATION_EXPERIENCE_ADDED = 'education_experience_added',
      EDUCATION_EXPERIENCE_DELETED = 'education_experience_deleted',
      ELEVATOR_PITCH_CREATED = 'elevator_pitch_created',
      EXPERIENCE_ADDED = 'experience_added',
      EXPERIENCE_REMOVED = 'experience_removed',
      ONBOARDING_COMPLETED = 'onboarding_completed',
      ONBOARDING_STARTED = 'onboarding_started',
      PERSON_ABOUT_ADDED = 'person_about_added',
      PERSON_ADDED = 'person_added',
      PERSON_ALREADY_ASSOCIATED_TO_USER = 'person_already_associated_to_user',
      PERSON_APPLIED = 'person_applied',
      PERSON_ASSOCIATED_TO_USER = 'person_associated_to_user',
      PERSON_ATTRIBUTE_ADDED = 'person_attribute_added',
      PERSON_ATTRIBUTE_REMOVED = 'person_attribute_removed',
      PERSON_CERTIFIED = 'person_certified',
      PERSON_SOURCED = 'person_sourced',
      CONTACT_PREFERENCE_SET = "contact_preference_set",
      SLACK_ID_ADDED = "slack_id_added",
      SKILL_LEVEL_UPDATED = 'skill_level_updated',
      PERSON_SKILL_ADDED = 'person_skill_added',
      PERSON_SKILL_REMOVED = 'person_skill_removed',
      PERSON_SKILL_UPDATED = 'person_skill_updated',
      PERSON_TRAINING_PROVIDER_ADDED = 'person_training_provider_added',
      PERSON_VIEWED = 'person_viewed',
      PERSONAL_EXPERIENCE_ADDED = 'personal_experience_added',
      PERSONAL_EXPERIENCE_REMOVED = 'personal_experience_removed',
      PROFESSIONAL_INTERESTS = "professional_interests",
      RELIABILITY_ADDED = 'relability_added',
      STORY_CREATED = 'story_created',
      STORY_DESTROYED = 'story_destroyed',
      STORY_UPDATED = 'story_updated',
      ZIP_ADDED = 'zip_added'
    ].freeze

    COMMANDS = [
      ADD_PERSON = 'add_person',
      ADD_NOTE = "add_note",
      COMPLETE_ONBOARDING = 'complete_onboarding',
      ASSIGN_COACH = "assign_coach",
      START_ONBOARDING = "start_onboarding"
    ].freeze
  end
end
