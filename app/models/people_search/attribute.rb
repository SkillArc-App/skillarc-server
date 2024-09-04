# == Schema Information
#
# Table name: people_search_attributes
#
#  id                 :bigint           not null, primary key
#  attribute_id       :uuid             not null
#  attribute_value_id :uuid             not null
#
# Indexes
#
#  index_people_search_attributes_on_attribute_id        (attribute_id)
#  index_people_search_attributes_on_attribute_value_id  (attribute_value_id)
#
module PeopleSearch
  class Attribute < ApplicationRecord
    has_many :attributes_people, class_name: "PeopleSearch::AttributePerson", dependent: :delete_all
    has_many :people, through: :attributes_people
  end
end
