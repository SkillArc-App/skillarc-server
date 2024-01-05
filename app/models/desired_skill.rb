# == Schema Information
#
# Table name: desired_skills
#
#  id              :text             not null, primary key
#  master_skill_id :text             not null
#  job_id          :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class DesiredSkill < ApplicationRecord
  belongs_to :master_skill
  belongs_to :job
end
