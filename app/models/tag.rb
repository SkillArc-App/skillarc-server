class Tag < ApplicationRecord
  has_many :job_tags, foreign_key: "tagId"
end
