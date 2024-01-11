# == Schema Information
#
# Table name: employer_invites
#
#  id          :text             not null, primary key
#  email       :text             not null
#  first_name  :text             not null
#  last_name   :text             not null
#  used_at     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employer_id :text             not null
#
# Foreign Keys
#
#  EmployerInvite_employer_id_fkey  (employer_id => employers.id) ON DELETE => restrict ON UPDATE => cascade
#
class EmployerInvite < ApplicationRecord
  belongs_to :employer
end
