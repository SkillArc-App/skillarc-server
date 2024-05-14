# == Schema Information
#
# Table name: job_orders_jobs
#
#  id               :uuid             not null, primary key
#  employer_name    :string           not null
#  employment_title :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  employer_id      :uuid             not null
#
# Indexes
#
#  index_job_orders_jobs_on_employer_id  (employer_id)
#
module JobOrders
  class Job < ApplicationRecord
    has_many :job_orders, class_name: "JobOrders::JobOrder", inverse_of: :job, dependent: :delete_all
  end
end
