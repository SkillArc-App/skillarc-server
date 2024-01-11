# == Schema Information
#
# Table name: training_provider_profiles
#
#  id                   :text             not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  training_provider_id :text             not null
#  user_id              :text             not null
#
# Indexes
#
#  TrainingProviderProfile_user_id_key  (user_id) UNIQUE
#
# Foreign Keys
#
#  TrainingProviderProfile_training_provider_id_fkey  (training_provider_id => training_providers.id) ON DELETE => restrict ON UPDATE => cascade
#  TrainingProviderProfile_user_id_fkey               (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#
class TrainingProviderProfile < ApplicationRecord
  belongs_to :training_provider
  belongs_to :user
  has_many :references, class_name: "Reference", foreign_key: "author_profile_id"
end
