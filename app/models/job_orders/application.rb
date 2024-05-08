# == Schema Information
#
# Table name: job_orders_applications
#
#  id                    :uuid             not null, primary key
#  status                :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  job_orders_jobs_id    :uuid             not null
#  job_orders_seekers_id :uuid             not null
#
# Indexes
#
#  index_job_orders_applications_on_job_orders_jobs_id     (job_orders_jobs_id)
#  index_job_orders_applications_on_job_orders_seekers_id  (job_orders_seekers_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_orders_jobs_id => job_orders_jobs.id)
#  fk_rails_...  (job_orders_seekers_id => job_orders_seekers.id)
#
module JobOrders
  class Application < ApplicationRecord
    belongs_to :job, class_name: "JobOrders::Job", foreign_key: "job_orders_jobs_id", inverse_of: :applications
    belongs_to :seeker, class_name: "JobOrders::Seeker", foreign_key: "job_orders_seekers_id", inverse_of: :applications
  end
end
