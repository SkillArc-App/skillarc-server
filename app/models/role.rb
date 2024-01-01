class Role < ApplicationRecord
  module Types
    ALL = [
      COACH = 'coach',
      EMPLOYER_ADMIN = 'employer_admin'
    ]
  end
end
