# == Schema Information
#
# Table name: seeker_references
#
#  id                   :text             not null, primary key
#  reference_text       :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  author_profile_id    :text             not null
#  seeker_profile_id    :text             not null
#  training_provider_id :text             not null
#
# Foreign Keys
#
#  Reference_author_profile_id_fkey     (author_profile_id => training_provider_profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  Reference_seeker_profile_id_fkey     (seeker_profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  Reference_training_provider_id_fkey  (training_provider_id => training_providers.id) ON DELETE => restrict ON UPDATE => cascade
#
class Reference < ApplicationRecord
  self.table_name = "seeker_references"

  belongs_to :author_profile, class_name: "TrainingProviderProfile"
  belongs_to :training_provider
  belongs_to :seeker_profile, class_name: "Profile"
end
