# == Schema Information
#
# Table name: learned_skills
#
#  id              :text             not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  job_id          :text             not null
#  master_skill_id :text             not null
#
# Foreign Keys
#
#  LearnedSkill_job_id_fkey           (job_id => jobs.id) ON DELETE => restrict ON UPDATE => cascade
#  LearnedSkill_master_skill_id_fkey  (master_skill_id => master_skills.id) ON DELETE => restrict ON UPDATE => cascade
#
class LearnedSkill < ApplicationRecord
  belongs_to :master_skill
end
