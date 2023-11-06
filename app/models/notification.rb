class Notification < ApplicationRecord
  belongs_to :user

  def read?
    read_at.present?
  end
end