class PersonalExperience < ApplicationRecord
  belongs_to :profile
  validates :profile_id, presence: true
end
