# == Schema Information
#
# Table name: people_search_attributes_people
#
#  attribute_id :bigint           not null
#  person_id    :uuid             not null
#
# Indexes
#
#  index_people_search_attributes_people_on_attribute_id  (attribute_id)
#  index_people_search_attributes_people_on_person_id     (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (attribute_id => people_search_attributes.id) ON DELETE => cascade
#  fk_rails_...  (person_id => people_search_people.id) ON DELETE => cascade
#
module PeopleSearch
  class AttributePerson < ApplicationRecord
    self.table_name = "people_search_attributes_people"

    belongs_to :person_attribute, class_name: "PeopleSearch::Attribute", foreign_key: 'attribute_id'
    belongs_to :person, class_name: "PeopleSearch::Person", foreign_key: 'person_id'
  end
end
