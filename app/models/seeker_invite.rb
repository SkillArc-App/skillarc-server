# == Schema Information
#
# Table name: seeker_invites
#
#  id                   :text             not null, primary key
#  email                :text             not null
#  first_name           :text             not null
#  last_name            :text             not null
#  program_id           :text             not null
#  training_provider_id :text             not null
#  used_at              :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class SeekerInvite < ApplicationRecord
  belongs_to :training_provider
  belongs_to :program
end
