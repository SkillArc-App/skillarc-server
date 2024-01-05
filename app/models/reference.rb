# == Schema Information
#
# Table name: seeker_references
#
#  id                   :text             not null, primary key
#  author_profile_id    :text             not null
#  seeker_profile_id    :text             not null
#  training_provider_id :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  reference_text       :text             not null
#
class Reference < ApplicationRecord
  self.table_name = "seeker_references"

  belongs_to :author_profile, class_name: "TrainingProviderProfile"
  belongs_to :training_provider
  belongs_to :seeker_profile, class_name: "Profile"
end
