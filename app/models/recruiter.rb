class Recruiter < ApplicationRecord
  self.table_name = "Recruiter"

  belongs_to :employer, foreign_key: "employerId", primary_key: "id"
  belongs_to :user, foreign_key: "userId", primary_key: "id"
end