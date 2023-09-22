class JobTag < ApplicationRecord
  self.table_name = "JobTag"

  belongs_to :job, foreign_key: "jobId"
  belongs_to :tag, foreign_key: "tagId"
end