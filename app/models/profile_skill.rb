# == Schema Information
#
# Table name: profile_skills
#
#  id              :text             not null, primary key
#  master_skill_id :text             not null
#  profile_id      :text             not null
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class ProfileSkill < ApplicationRecord
  belongs_to :master_skill
  belongs_to :profile
end
