class Employer < ApplicationRecord
  self.table_name = "Employer"

  has_many :jobs
end