# == Schema Information
#
# Table name: roles
#
#  id         :text             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Role < ApplicationRecord
  module Types
    ALL = [
      COACH = 'coach',
      EMPLOYER_ADMIN = 'employer_admin'
    ]
  end
end
