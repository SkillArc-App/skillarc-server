# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  body       :string
#  read_at    :datetime
#  title      :string
#  type       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :text             not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read_at: nil) }

  def read?
    read_at.present?
  end
end
