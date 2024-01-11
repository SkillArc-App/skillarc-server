# == Schema Information
#
# Table name: seeker_invites
#
#  id                   :text             not null, primary key
#  email                :text             not null
#  first_name           :text             not null
#  last_name            :text             not null
#  used_at              :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  program_id           :text             not null
#  training_provider_id :text             not null
#
# Foreign Keys
#
#  SeekerInvite_program_id_fkey            (program_id => programs.id) ON DELETE => restrict ON UPDATE => cascade
#  SeekerInvite_training_provider_id_fkey  (training_provider_id => training_providers.id) ON DELETE => restrict ON UPDATE => cascade
#
class SeekerInvite < ApplicationRecord
  belongs_to :training_provider
  belongs_to :program
end
