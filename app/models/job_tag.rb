class JobTag < ApplicationRecord
  self.table_name = "JobTag"

  belongs_to :job, foreign_key: "job_id"
  belongs_to :tag, foreign_key: "tag_id"
end