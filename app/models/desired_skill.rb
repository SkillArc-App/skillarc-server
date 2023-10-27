class DesiredSkill < ApplicationRecord
  belongs_to :master_skill
  belongs_to :job
end
