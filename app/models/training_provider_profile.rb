# == Schema Information
#
# Table name: training_provider_profiles
#
#  id                   :text             not null, primary key
#  training_provider_id :text             not null
#  user_id              :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class TrainingProviderProfile < ApplicationRecord
  belongs_to :training_provider
  belongs_to :user
  has_many :references, class_name: "Reference", foreign_key: "author_profile_id"
end
