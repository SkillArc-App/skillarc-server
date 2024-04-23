# == Schema Information
#
# Table name: attributes_attributes
#
#  id          :uuid             not null, primary key
#  default     :string           not null, is an Array
#  description :text
#  name        :string
#  set         :string           not null, is an Array
#
module Attributes
  class Attribute < ApplicationRecord
  end
end
