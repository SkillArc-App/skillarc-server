# == Schema Information
#
# Table name: analytics_fact_communications
#
#  id                      :bigint           not null, primary key
#  direction               :string           not null
#  kind                    :string           not null
#  occurred_at             :datetime         not null
#  analytics_dim_people_id :bigint           not null
#  analytics_dim_users_id  :bigint           not null
#
# Indexes
#
#  index_analytics_fact_communications_on_analytics_dim_people_id  (analytics_dim_people_id)
#  index_analytics_fact_communications_on_analytics_dim_users_id   (analytics_dim_users_id)
#
# Foreign Keys
#
#  fk_rails_...  (analytics_dim_people_id => analytics_dim_people.id)
#  fk_rails_...  (analytics_dim_users_id => analytics_dim_users.id)
#
module Analytics
  class FactCommunication < ApplicationRecord
    belongs_to :dim_person, class_name: "Analytics::DimPerson", foreign_key: "analytics_dim_people_id", inverse_of: :fact_communications
    belongs_to :dim_user, class_name: "Analytics::DimUser", foreign_key: "analytics_dim_users_id", inverse_of: :fact_communications
  end
end
