# == Schema Information
#
# Table name: seeker_training_providers
#
#  id                   :text             not null, primary key
#  training_provider_id :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  program_id           :text
#  user_id              :text             not null
#
class SeekerTrainingProvider < ApplicationRecord
  belongs_to :user
  belongs_to :training_provider
  belongs_to :program, optional: true

  has_many :program_statuses, class_name: 'SeekerTrainingProviderProgramStatus', dependent: :destroy

  validates :user_id, presence: true
  validates :training_provider_id, presence: true
end
