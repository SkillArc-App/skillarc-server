# == Schema Information
#
# Table name: job_orders_candidates
#
#  id                       :uuid             not null, primary key
#  status                   :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  job_orders_job_orders_id :uuid             not null
#  job_orders_seekers_id    :uuid             not null
#
# Indexes
#
#  index_job_orders_candidates_on_job_orders_job_orders_id  (job_orders_job_orders_id)
#  index_job_orders_candidates_on_job_orders_seekers_id     (job_orders_seekers_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_orders_job_orders_id => job_orders_job_orders.id)
#  fk_rails_...  (job_orders_seekers_id => job_orders_seekers.id)
#
module JobOrders
  class Candidate < ApplicationRecord
    belongs_to :job_order, class_name: "JobOrders::JobOrder", foreign_key: "job_orders_job_orders_id", inverse_of: :candidates
    belongs_to :seeker, class_name: "JobOrders::Seeker", foreign_key: "job_orders_seekers_id", inverse_of: :candidates

    def job_order_id
      job_orders_job_orders_id
    end

    def seeker_id
      job_orders_seekers_id
    end
  end
end
