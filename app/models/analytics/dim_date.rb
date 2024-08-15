# == Schema Information
#
# Table name: analytics_dim_dates
#
#  id          :bigint           not null, primary key
#  date        :date             not null
#  datetime    :datetime         not null
#  day         :integer          not null
#  day_of_week :string           not null
#  month       :integer          not null
#
# Indexes
#
#  index_analytics_dim_dates_on_date      (date)
#  index_analytics_dim_dates_on_datetime  (datetime)
#
module Analytics
  class DimDate < ApplicationRecord
  end
end
