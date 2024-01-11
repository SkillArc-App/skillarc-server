# == Schema Information
#
# Table name: program_skills
#
#  id         :text             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  program_id :text             not null
#  skill_id   :text             not null
#
# Foreign Keys
#
#  ProgramSkill_program_id_fkey  (program_id => programs.id) ON DELETE => restrict ON UPDATE => cascade
#  ProgramSkill_skill_id_fkey    (skill_id => master_skills.id) ON DELETE => restrict ON UPDATE => cascade
#
class ProgramSkill < ApplicationRecord
end
