# == Schema Information
#
# Table name: seekers
#
#  id         :uuid             not null, primary key
#  bio        :string
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :text             not null
#
# Indexes
#
#  index_seekers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Seeker < ApplicationRecord
  belongs_to :user

  has_many :applicants
  has_many :education_experiences
  has_many :other_experiences
  has_many :personal_experiences
  has_many :profile_skills
  has_many :references, class_name: "Reference"
end
