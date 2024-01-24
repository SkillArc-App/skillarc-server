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
#  seeker_id  :uuid
#
# Indexes
#
#  index_stories_on_seeker_id  (seeker_id)
#
# Foreign Keys
#
#  Story_profile_id_fkey  (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...           (seeker_id => seekers.id)
#
class Story < ApplicationRecord
  belongs_to :profile
  belongs_to :seeker, optional: true
end
