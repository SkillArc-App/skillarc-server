# == Schema Information
#
# Table name: profile_skills
#
#  id              :text             not null, primary key
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  master_skill_id :text             not null
#  profile_id      :text             not null
#
# Foreign Keys
#
#  ProfileSkill_master_skill_id_fkey  (master_skill_id => master_skills.id) ON DELETE => restrict ON UPDATE => cascade
#  ProfileSkill_profile_id_fkey       (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class ProfileSkill < ApplicationRecord
  belongs_to :master_skill
  belongs_to :profile
end
