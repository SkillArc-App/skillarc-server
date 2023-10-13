class Recruiter < ApplicationRecord
  belongs_to :employer
  belongs_to :user
end
