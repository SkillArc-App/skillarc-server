# == Schema Information
#
# Table name: recruiters
#
#  id          :text             not null, primary key
#  user_id     :text             not null
#  employer_id :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Recruiter < ApplicationRecord
  belongs_to :employer
  belongs_to :user
end
