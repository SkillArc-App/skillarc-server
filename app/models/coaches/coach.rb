# == Schema Information
#
# Table name: coaches
#
#  id         :uuid             not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  coach_id   :uuid             not null
#  user_id    :string           not null
#
module Coaches
  class Coach < ApplicationRecord
  end
end
