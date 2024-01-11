# == Schema Information
#
# Table name: recruiters
#
#  id          :text             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employer_id :text             not null
#  user_id     :text             not null
#
# Foreign Keys
#
#  Recruiter_employer_id_fkey  (employer_id => employers.id) ON DELETE => restrict ON UPDATE => cascade
#  Recruiter_user_id_fkey      (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#
class Recruiter < ApplicationRecord
  belongs_to :employer
  belongs_to :user
end
