# == Schema Information
#
# Table name: career_paths
#
#  id          :text             not null, primary key
#  title       :text             not null
#  upper_limit :text             not null
#  lower_limit :text             not null
#  order       :integer          not null
#  job_id      :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class CareerPath < ApplicationRecord
  belongs_to :job
end
