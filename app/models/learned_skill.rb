# == Schema Information
#
# Table name: learned_skills
#
#  id              :text             not null, primary key
#  master_skill_id :text             not null
#  job_id          :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class LearnedSkill < ApplicationRecord
  belongs_to :master_skill
end
