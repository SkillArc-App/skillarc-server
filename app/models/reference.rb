# == Schema Information
#
# Table name: seeker_references
#
#  id                   :text             not null, primary key
#  reference_text       :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  author_profile_id    :text             not null
#  seeker_id            :uuid             not null
#  training_provider_id :text             not null
#
# Indexes
#
#  index_seeker_references_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  Reference_author_profile_id_fkey     (author_profile_id => training_provider_profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  Reference_training_provider_id_fkey  (training_provider_id => training_providers.id) ON DELETE => restrict ON UPDATE => cascade
#
class Reference < ApplicationRecord
  self.table_name = "seeker_references"

  belongs_to :author_profile, class_name: "TrainingProviderProfile"
  has_one :user, through: :author_profile
  belongs_to :training_provider
end
