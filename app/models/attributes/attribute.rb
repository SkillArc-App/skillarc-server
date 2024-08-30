# == Schema Information
#
# Table name: attributes_attributes
#
#  id              :uuid             not null, primary key
#  default         :jsonb            not null
#  description     :text
#  machine_derived :boolean          default(FALSE), not null
#  name            :string           not null
#  set             :jsonb            not null
#
module Attributes
  class Attribute < ApplicationRecord
  end
end
