class TrainingProviderProfile < ApplicationRecord
  belongs_to :training_provider
  belongs_to :user
  has_many :references, class_name: "Reference", foreign_key: "author_profile_id"
end
