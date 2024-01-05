# == Schema Information
#
# Table name: program_skills
#
#  id         :text             not null, primary key
#  program_id :text             not null
#  skill_id   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProgramSkill < ApplicationRecord
end
