# == Schema Information
#
# Table name: coaches_jobs
#
#  id               :uuid             not null, primary key
#  employer_name    :string
#  employment_title :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  job_id           :uuid             not null
#
# Indexes
#
#  index_coaches_jobs_on_job_id  (job_id)
#
module Coaches
  class Job < ApplicationRecord
    self.table_name = "coaches_jobs"
  end
end
