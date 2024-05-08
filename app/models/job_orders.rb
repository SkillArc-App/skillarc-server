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

  module CloseStatus
    ALL = [
      FILLED = "filled",
      NOT_FILLED = 'not_filled'
    ].freeze
  end

  module IdleStatus
    ALL = [
      WAITING_ON_EMPLOYER = "waiting_on_employer"
    ].freeze
  end
end
