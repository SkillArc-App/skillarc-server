# == Schema Information
#
# Table name: coach_seeker_contexts
#
#  id                :uuid             not null, primary key
#  user_id           :string           not null
#  profile_id        :uuid
#  first_name        :string
#  last_name         :string
#  email             :string
#  phone_number      :string
#  assigned_coach    :string
#  skill_level       :string
#  stage             :string
#  barriers          :string           default([]), is an Array
#  last_contacted_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  last_active_on    :datetime
#
module Coaches
  class CoachSeekerContext < ApplicationRecord
    has_many :seeker_notes, dependent: :destroy, class_name: "Coaches::SeekerNote"
    has_many :seeker_applications, dependent: :destroy, class_name: "Coaches::SeekerApplication"
  end
end
