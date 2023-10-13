class ProfileSkill < ApplicationRecord
  belongs_to :master_skill
  belongs_to :profile
end
