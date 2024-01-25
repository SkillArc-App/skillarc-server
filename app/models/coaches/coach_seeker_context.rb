# == Schema Information
#
# Table name: coach_seeker_contexts
#
#  id                :uuid             not null, primary key
#  assigned_coach    :string
#  email             :string
#  first_name        :string
#  last_active_on    :datetime
#  last_contacted_at :datetime
#  last_name         :string
#  phone_number      :string
#  skill_level       :string
#  stage             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  profile_id        :uuid
#  seeker_id         :uuid
#  user_id           :string           not null
#
module Coaches
  class CoachSeekerContext < ApplicationRecord
    has_many :seeker_notes, dependent: :destroy, class_name: "Coaches::SeekerNote"
    has_many :seeker_applications, dependent: :destroy, class_name: "Coaches::SeekerApplication"
  end
end
