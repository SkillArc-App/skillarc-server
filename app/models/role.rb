# == Schema Information
#
# Table name: roles
#
#  id         :text             not null, primary key
#  name       :text             not null
#  uuid       :uuid             not null
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
      COACH = 'coach'.freeze,
      EMPLOYER_ADMIN = 'employer_admin'.freeze
    ].freeze
  end
end
