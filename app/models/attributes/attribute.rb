# == Schema Information
#
# Table name: attributes_attributes
#
#  id              :uuid             not null, primary key
#  default         :string           not null, is an Array
#  description     :text
#  machine_derived :boolean          default(FALSE), not null
#  name            :string           not null
#  set             :string           not null, is an Array
#
module Attributes
  class Attribute < ApplicationRecord
  end
end
