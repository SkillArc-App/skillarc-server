# == Schema Information
#
# Table name: analytics_fact_person_vieweds
#
#  id                             :bigint           not null, primary key
#  viewed_at                      :datetime         not null
#  viewing_context                :string           not null
#  analytics_dim_person_viewed_id :bigint           not null
#  analytics_dim_person_viewer_id :bigint           not null
#
# Indexes
#
#  idx_on_analytics_dim_person_viewed_id_15c412a0ed  (analytics_dim_person_viewed_id)
#  idx_on_analytics_dim_person_viewer_id_856d86a762  (analytics_dim_person_viewer_id)
#
# Foreign Keys
#
#  fk_rails_...  (analytics_dim_person_viewed_id => analytics_dim_people.id)
#  fk_rails_...  (analytics_dim_person_viewer_id => analytics_dim_people.id)
#
module Analytics
  class FactPersonViewed < ApplicationRecord
    self.table_name = "analytics_fact_person_vieweds"

    module Contexts
      ALL = [
        PUBLIC_PROFILE = 'public_profile'.freeze,
        COACHES_DASHBOARD = "coaches_dashboard".freeze
      ].freeze
    end

    validates :viewing_context, presence: true, on: :create
    belongs_to :dim_person_viewed, class_name: "Analytics::DimPerson", foreign_key: "analytics_dim_person_viewed_id", inverse_of: :fact_applications
    belongs_to :dim_person_viewer, class_name: "Analytics::DimPerson", foreign_key: "analytics_dim_person_viewer_id", inverse_of: :fact_applications
  end
end
