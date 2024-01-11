# == Schema Information
#
# Table name: stories
#
#  id         :text             not null, primary key
#  prompt     :text             not null
#  response   :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :text             not null
#
# Foreign Keys
#
#  Story_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class Story < ApplicationRecord
  belongs_to :profile
end
