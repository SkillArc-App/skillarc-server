# == Schema Information
#
# Table name: analytics_dim_users
#
#  id              :bigint           not null, primary key
#  email           :string
#  first_name      :string
#  last_active_at  :datetime
#  last_name       :string
#  user_created_at :datetime         not null
#  user_id         :string           not null
#
module Analytics
  class DimUser < ApplicationRecord
    self.table_name = "analytics_dim_users"
  end
end
