# == Schema Information
#
# Table name: employer_invites
#
#  id          :text             not null, primary key
#  email       :text             not null
#  first_name  :text             not null
#  last_name   :text             not null
#  employer_id :text             not null
#  used_at     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class EmployerInvite < ApplicationRecord
  belongs_to :employer
end
