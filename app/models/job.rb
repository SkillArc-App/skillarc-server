class Job < ApplicationRecord
  self.table_name = "Job"

  belongs_to :employer, foreign_key: "employerId"
end