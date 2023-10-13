class Program < ApplicationRecord
  has_many :students, class_name: 'SeekerTrainingProvider'
  has_many :seeker_invites
end
