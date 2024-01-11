# == Schema Information
#
# Table name: user_roles
#
#  id         :text             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :text             not null
#  user_id    :text             not null
#
# Foreign Keys
#
#  UserRoles_role_id_fkey  (role_id => roles.id) ON DELETE => restrict ON UPDATE => cascade
#  UserRoles_user_id_fkey  (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#
class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
