# == Schema Information
#
# Table name: job_photos
#
#  id         :text             not null, primary key
#  photo_url  :text             not null
#  job_id     :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JobPhoto < ApplicationRecord
  belongs_to :job
end
