# == Schema Information
#
# Table name: job_tags
#
#  id         :text             not null, primary key
#  job_id     :text             not null
#  tag_id     :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JobTag < ApplicationRecord
  belongs_to :job, foreign_key: "job_id"
  belongs_to :tag, foreign_key: "tag_id"
end
