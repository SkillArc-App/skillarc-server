# == Schema Information
#
# Table name: job_orders_seekers
#
#  id           :uuid             not null, primary key
#  email        :string
#  first_name   :string
#  last_name    :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
module JobOrders
  class Seeker < ApplicationRecord
    has_many :applications, class_name: "JobOrders::Application", inverse_of: :seeker, dependent: :delete_all
    has_many :candidates, class_name: "JobOrders::Candidate", inverse_of: :seeker, dependent: :delete_all
  end
end
