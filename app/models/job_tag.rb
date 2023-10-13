class JobTag < ApplicationRecord
  belongs_to :job, foreign_key: "job_id"
  belongs_to :tag, foreign_key: "tag_id"
end
