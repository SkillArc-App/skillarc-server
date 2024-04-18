# == Schema Information
#
# Table name: coaches
#
#  id                :uuid             not null, primary key
#  assignment_weight :float            default(1.0), not null
#  email             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  coach_id          :uuid
#  user_id           :string           not null
#
module Coaches
  class Coach < ApplicationRecord
    has_many :reminders, class_name: "Coaches::Reminder", dependent: :destroy
  end
end
