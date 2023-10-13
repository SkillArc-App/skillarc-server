class TrainingProvider < ApplicationRecord
  has_many :programs
  has_many :seeker_invites
end
