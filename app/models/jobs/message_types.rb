# frozen_string_literal: true

module Jobs
  module MessageTypes
    EVENTS = [
      ADD_DESIRED_CERTIFICATION = "add_desired_certification",
      REMOVE_DESIRED_CERTIFICATION = "remove_desired_certification"
    ].freeze

    COMMANDS = [
      CAREER_PATH_CREATED = 'career_path_created',
      CAREER_PATH_UPDATED = 'career_path_updated',
      CAREER_PATH_DESTROYED = 'career_path_destroyed',
      DESIRED_CERTIFICATION_CREATED = 'desired_certification_created',
      DESIRED_CERTIFICATION_DESTROYED = 'desired_certification_destroyed',
      DESIRED_SKILL_CREATED = 'desired_skill_created',
      DESIRED_SKILL_DESTROYED = 'desired_skill_destroyed',
      JOB_ATTRIBUTE_CREATED = 'job_attribute_created',
      JOB_ATTRIBUTE_DESTROYED = 'job_attribute_destroyed',
      JOB_ATTRIBUTE_UPDATED = 'job_attribute_updated',
      JOB_CREATED = 'job_created',
      JOB_UPDATED = 'job_updated',
      JOB_PHOTO_CREATED = 'job_photo_created',
      JOB_PHOTO_DESTROYED = 'job_photo_destroyed',
      LEARNED_SKILL_CREATED = 'learned_skill_created',
      LEARNED_SKILL_DESTROYED = 'learned_skill_destroyed',
      JOB_TAG_CREATED = 'job_tag_created',
      JOB_TAG_DELETED = 'job_tag_deleted',
      TESTIMONIAL_CREATED = 'testimonial_created',
      TESTIMONIAL_DESTROYED = 'testimonial_destroyed'
    ].freeze
  end
end
