# == Schema Information
#
# Table name: analytics_fact_job_order_statuses
#
#  id                         :bigint           not null, primary key
#  ended_at                   :datetime
#  started_at                 :datetime         not null
#  status                     :string           not null
#  analytics_dim_job_order_id :bigint           not null
#
# Indexes
#
#  idx_on_analytics_dim_job_order_id_c1a425e074  (analytics_dim_job_order_id)
#
# Foreign Keys
#
#  fk_rails_...  (analytics_dim_job_order_id => analytics_dim_job_orders.id)
#
module Analytics
  class FactJobOrderStatus < ApplicationRecord
    belongs_to :dim_job_order, class_name: "Analytics::DimJobOrder", foreign_key: "analytics_dim_job_order_id", inverse_of: :fact_job_order_statuses

    validates :status, inclusion: { in: OrderStatus::ALL }
  end
end
