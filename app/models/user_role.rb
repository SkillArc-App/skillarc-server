# == Schema Information
#
# Table name: user_roles
#
#  id         :text             not null, primary key
#  user_id    :text             not null
#  role_id    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
