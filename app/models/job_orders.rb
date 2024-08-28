# frozen_string_literal: true

module JobOrders
  def self.table_name_prefix
    "job_orders_"
  end

  module CandidateStatus
    ALL = [
      ADDED = "added",
      RECOMMENDED = "recommended",
      SCREENED = "screened",
      HIRED = "hired",
      RESCINDED = 'rescinded'
    ].freeze
  end

  module OrderStatus
    ALL = [
      NEEDS_ORDER_COUNT = "needs_order_count",
      NEEDS_CRITERIA = "needs_criteria",
      NEEDS_SCREENER_OR_BYPASS = "needs_screener_or_bypass",
      OPEN = "open",
      CANDIDATES_SCREENED = "candidates_screened",
      WAITING_ON_EMPLOYER = "waiting_on_employer",
      FILLED = "filled",
      NOT_FILLED = 'not_filled'
    ].freeze
  end

  module ActivatedStatus
    ALL = [
      NEEDS_ORDER_COUNT = OrderStatus::NEEDS_ORDER_COUNT,
      NEEDS_CRITERIA = OrderStatus::NEEDS_CRITERIA,
      OPEN = OrderStatus::OPEN,
      CANDIDATES_SCREENED = OrderStatus::CANDIDATES_SCREENED
    ].freeze
  end

  module ClosedStatus
    ALL = [
      FILLED = OrderStatus::FILLED,
      NOT_FILLED = OrderStatus::NOT_FILLED
    ].freeze
  end

  module StalledStatus
    ALL = [
      WAITING_ON_EMPLOYER = OrderStatus::WAITING_ON_EMPLOYER
    ].freeze
  end
end
