# == Schema Information
#
# Table name: coaches_seeker_leads
#
#  id               :uuid             not null, primary key
#  email            :string
#  first_name       :string           not null
#  last_name        :string           not null
#  lead_captured_at :datetime         not null
#  lead_captured_by :string           not null
#  phone_number     :string           not null
#  status           :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  lead_id          :uuid             not null
#
# Indexes
#
#  index_coaches_seeker_leads_on_email         (email) UNIQUE WHERE (email IS NOT NULL)
#  index_coaches_seeker_leads_on_phone_number  (phone_number) UNIQUE
#
module Coaches
  class SeekerLead < ApplicationRecord
    self.table_name = "coaches_seeker_leads"

    module StatusTypes
      ALL = [
        NEW = "new".freeze,
        CONVERTED = "converted".freeze
      ].freeze
    end

    validates :lead_id, presence: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :phone_number, presence: true
    validates :status, presence: true
    validates :lead_captured_at, presence: true
    validates :lead_captured_by, presence: true

    validates :status, inclusion: { in: StatusTypes::ALL }
  end
end
