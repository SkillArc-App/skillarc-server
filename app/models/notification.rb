# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  type       :string
#  title      :string
#  body       :string
#  url        :string
#  user_id    :text             not null
#  read_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read_at: nil) }

  def read?
    read_at.present?
  end
end
