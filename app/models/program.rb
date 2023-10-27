class Program < ApplicationRecord
  belongs_to :training_provider

  has_many :students, class_name: 'SeekerTrainingProvider'
  has_many :seeker_invites
end
