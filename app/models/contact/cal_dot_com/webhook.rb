# == Schema Information
#
# Table name: contact_cal_dot_com_webhooks
#
#  id                     :bigint           not null, primary key
#  cal_dot_com_event_type :string           not null
#  occurred_at            :datetime         not null
#  payload                :jsonb            not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
module Contact
  module CalDotCom
    class Webhook < ApplicationRecord
      self.table_name = 'contact_cal_dot_com_webhooks'
    end
  end
end
