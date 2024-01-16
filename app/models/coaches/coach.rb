# == Schema Information
#
# Table name: coaches
#
#  id         :uuid             not null, primary key
#  user_id    :string           not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Coaches
  class Coach < ApplicationRecord
  end
end
