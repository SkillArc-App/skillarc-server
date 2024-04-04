# == Schema Information
#
# Table name: analytics_dim_jobs
#
#  id               :bigint           not null, primary key
#  category         :string           not null
#  employment_title :string           not null
#  employment_type  :string           not null
#  job_created_at   :datetime         not null
#  job_id           :uuid             not null
#
# Indexes
#
#  index_analytics_dim_jobs_on_employment_type  (employment_type)
#  index_analytics_dim_jobs_on_job_id           (job_id)
#
module Analytics
  class DimJob < ApplicationRecord
    self.table_name = "analytics_dim_jobs"

    has_many :fact_applications, class_name: "Analytics::FactApplication", dependent: :delete_all
    has_many :fact_job_visibilities, class_name: "Analytics::FactJobVisibility", dependent: :delete_all
  end
end
