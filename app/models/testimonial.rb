# == Schema Information
#
# Table name: testimonials
#
#  id          :text             not null, primary key
#  job_id      :text             not null
#  name        :text             not null
#  title       :text             not null
#  testimonial :text             not null
#  photo_url   :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Testimonial < ApplicationRecord
  belongs_to :job
end
