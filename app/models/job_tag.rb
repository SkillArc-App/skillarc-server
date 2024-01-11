# == Schema Information
#
# Table name: job_tags
#
#  id         :text             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :text             not null
#  tag_id     :text             not null
#
# Foreign Keys
#
#  JobTag_job_id_fkey  (job_id => jobs.id) ON DELETE => restrict ON UPDATE => cascade
#  JobTag_tag_id_fkey  (tag_id => tags.id) ON DELETE => restrict ON UPDATE => cascade
#
class JobTag < ApplicationRecord
  belongs_to :job, foreign_key: "job_id"
  belongs_to :tag, foreign_key: "tag_id"
end
