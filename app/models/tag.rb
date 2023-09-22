class Tag < ApplicationRecord
  self.table_name = "Tag"

  has_many :job_tags, foreign_key: "tagId"
end