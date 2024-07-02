# frozen_string_literal: true

module JobOrders
  module MessageTypes
    EVENTS = [
      JOB_ORDER_ADDED = 'job_order_added',
      JOB_ORDER_CREATION_FAILED = 'job_order_creation_failed',
      JOB_ORDER_ORDER_COUNT_ADDED = 'job_order_order_count_added',
      JOB_ORDER_ACTIVATED = 'job_order_activated',
      JOB_ORDER_ACTIVATION_FAILED = 'job_order_activation_failed',
      JOB_ORDER_NOTE_ADDED = 'job_order_note_added',
      JOB_ORDER_NOTE_MODIFIED = 'job_order_note_modified',
      JOB_ORDER_NOTE_REMOVED = 'job_order_note_removed',
      JOB_ORDER_STALLED = 'job_order_stalled',
      JOB_ORDER_FILLED = 'job_order_filled',
      JOB_ORDER_NOT_FILLED = 'job_order_not_filled',
      JOB_ORDER_CANDIDATE_ADDED = 'job_order_candidate_added',
      JOB_ORDER_CANDIDATE_APPLIED = 'job_order_candidate_applied',
      JOB_ORDER_CANDIDATE_HIRED = 'job_order_candidate_hired',
      JOB_ORDER_CANDIDATE_RECOMMENDED = 'job_order_candidate_recommended',
      JOB_ORDER_CANDIDATE_RESCINDED = 'job_order_candidate_rescinded'
    ].freeze

    COMMANDS = [
      ADD_JOB_ORDER = 'add_job_order',
      ACTIVATE_JOB_ORDER = 'activate_job_order'
    ].freeze
  end
end
