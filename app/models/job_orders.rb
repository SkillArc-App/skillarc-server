# frozen_string_literal: true

module JobOrders
  def self.table_name_prefix
    "job_orders_"
  end

  module CandidateStatus
    ALL = [
      ADDED = "added",
      RECOMMENDED = "recommended",
      HIRED = "hired",
      RESCINDED = 'rescinded'
    ].freeze
  end

  module ActivatedStatus
    ALL = [
      OPEN = "open"
    ].freeze
  end

  module ClosedStatus
    ALL = [
      FILLED = "filled",
      NOT_FILLED = 'not_filled'
    ].freeze
  end

  module StalledStatus
    ALL = [
      WAITING_ON_EMPLOYER = "waiting_on_employer"
    ].freeze
  end

  module OrderStatus
    ALL = [
      *ActivatedStatus::ALL,
      *ClosedStatus::ALL,
      *StalledStatus::ALL
    ].freeze
  end
end
