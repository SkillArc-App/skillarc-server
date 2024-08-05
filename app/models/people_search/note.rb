# == Schema Information
#
# Table name: people_search_notes
#
#  id        :uuid             not null, primary key
#  note      :text             not null
#  person_id :uuid             not null
#
# Indexes
#
#  index_people_search_notes_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people_search_people.id) ON DELETE => cascade
#
module PeopleSearch
  class Note < ApplicationRecord
    belongs_to :person, class_name: "PeopleSearch::Person"
  end
end
