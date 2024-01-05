# == Schema Information
#
# Table name: programs
#
#  id                   :text             not null, primary key
#  name                 :text             not null
#  description          :text             not null
#  training_provider_id :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Program < ApplicationRecord
  belongs_to :training_provider

  has_many :students, class_name: 'SeekerTrainingProvider'
  has_many :seeker_invites
end
