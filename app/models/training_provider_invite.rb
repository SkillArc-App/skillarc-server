# == Schema Information
#
# Table name: training_provider_invites
#
#  id                   :text             not null, primary key
#  email                :text             not null
#  first_name           :text             not null
#  last_name            :text             not null
#  role_description     :text             not null
#  training_provider_id :text             not null
#  used_at              :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class TrainingProviderInvite < ApplicationRecord
  belongs_to :training_provider
end
