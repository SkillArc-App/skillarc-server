# == Schema Information
#
# Table name: roles
#
#  id         :text             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  Role_name_key  (name) UNIQUE
#
class Role < ApplicationRecord
  module Types
    ALL = [
      COACH = 'coach',
      EMPLOYER_ADMIN = 'employer_admin'
    ]
  end
end
