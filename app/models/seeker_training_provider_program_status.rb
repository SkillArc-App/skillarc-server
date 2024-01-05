# == Schema Information
#
# Table name: seeker_training_provider_program_statuses
#
#  id                          :text             not null, primary key
#  seeker_training_provider_id :text             not null
#  status                      :text             default("enrolled"), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
class SeekerTrainingProviderProgramStatus < ApplicationRecord
  belongs_to :seeker_training_provider
end
