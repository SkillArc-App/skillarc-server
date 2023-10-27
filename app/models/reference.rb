class Reference < ApplicationRecord
  self.table_name = "seeker_references"

  belongs_to :author_profile, class_name: "TrainingProviderProfile"
  belongs_to :training_provider
  belongs_to :seeker_profile, class_name: "Profile"
end
