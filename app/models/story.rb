# == Schema Information
#
# Table name: stories
#
#  id         :text             not null, primary key
#  profile_id :text             not null
#  prompt     :text             not null
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Story < ApplicationRecord
  belongs_to :profile
end
