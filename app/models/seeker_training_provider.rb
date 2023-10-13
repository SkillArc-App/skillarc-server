class SeekerTrainingProvider < ApplicationRecord
  belongs_to :user
  belongs_to :training_provider
  belongs_to :program, optional: true

  has_many :program_statuses, class_name: 'SeekerTrainingProviderProgramStatus', dependent: :destroy

  validates :user_id, presence: true
  validates :training_provider_id, presence: true
end
