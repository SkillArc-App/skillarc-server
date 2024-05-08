# == Schema Information
#
# Table name: job_orders_job_orders
#
#  id                 :uuid             not null, primary key
#  applicant_count    :integer          not null
#  candidate_count    :integer          not null
#  closed_at          :datetime
#  hire_count         :integer          not null
#  order_count        :integer
#  recommended_count  :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  job_orders_jobs_id :uuid             not null
#
# Indexes
#
#  index_job_orders_job_orders_on_job_orders_jobs_id  (job_orders_jobs_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_orders_jobs_id => job_orders_jobs.id)
#
module JobOrders
  class JobOrder < ApplicationRecord
    belongs_to :job, class_name: "JobOrders::Job", foreign_key: "job_orders_jobs_id", inverse_of: :job_orders
    has_many :candidates, class_name: "JobOrders::Candidate", inverse_of: :job_order, dependent: :delete_all
  end
end
