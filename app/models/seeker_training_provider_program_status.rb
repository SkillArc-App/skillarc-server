# == Schema Information
#
# Table name: seeker_training_provider_program_statuses
#
#  id                          :text             not null, primary key
#  status                      :text             default("enrolled"), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  seeker_training_provider_id :text             not null
#
# Foreign Keys
#
#  seeker_training_provider_program_statuses_seeker_training__fkey  (seeker_training_provider_id => seeker_training_providers.id) ON DELETE => restrict ON UPDATE => cascade
#
class SeekerTrainingProviderProgramStatus < ApplicationRecord
  belongs_to :seeker_training_provider
end
