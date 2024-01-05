# == Schema Information
#
# Table name: reasons
#
#  id          :uuid             not null, primary key
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Reason < ApplicationRecord
end
