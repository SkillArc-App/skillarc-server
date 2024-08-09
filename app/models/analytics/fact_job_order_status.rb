# == Schema Information
#
# Table name: analytics_fact_job_order_statuses
#
#  id                          :bigint           not null, primary key
#  status                      :string           not null
#  status_ended                :datetime
#  status_started              :datetime         not null
#  analytics_dim_job_orders_id :bigint           not null
#
# Indexes
#
#  idx_on_analytics_dim_job_orders_id_3b66b7e1ac  (analytics_dim_job_orders_id)
#
# Foreign Keys
#
#  fk_rails_...  (analytics_dim_job_orders_id => analytics_dim_job_orders.id)
#
module Analytics
  class FactJobOrderStatus < ApplicationRecord
    belongs_to :dim_job_order, class_name: "Analytics::DimJobOrder", foreign_key: "analytics_dim_job_orders_id", inverse_of: :fact_candidates
  end
end
