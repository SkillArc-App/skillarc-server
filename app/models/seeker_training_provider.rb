# == Schema Information
#
# Table name: seeker_training_providers
#
#  id                   :text             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  program_id           :text
#  training_provider_id :text             not null
#  user_id              :text             not null
#
# Foreign Keys
#
#  SeekerTrainingProvider_program_id_fkey            (program_id => programs.id) ON DELETE => nullify ON UPDATE => cascade
#  SeekerTrainingProvider_training_provider_id_fkey  (training_provider_id => training_providers.id) ON DELETE => restrict ON UPDATE => cascade
#  SeekerTrainingProvider_user_id_fkey               (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#
class SeekerTrainingProvider < ApplicationRecord
  belongs_to :user
  belongs_to :training_provider
  belongs_to :program, optional: true

  has_many :program_statuses, class_name: 'SeekerTrainingProviderProgramStatus', dependent: :destroy

  validates :user_id, presence: true
  validates :training_provider_id, presence: true
end
