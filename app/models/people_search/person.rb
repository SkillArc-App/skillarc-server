# == Schema Information
#
# Table name: people_search_people
#
#  id                :uuid             not null, primary key
#  certified_by      :string
#  date_of_birth     :date
#  email             :string
#  first_name        :string
#  last_name         :string
#  phone_number      :string
#  search_vector     :text             not null
#  assigned_coach_id :uuid
#  user_id           :string
#
# Indexes
#
#  index_people_search_people_on_assigned_coach_id  (assigned_coach_id)
#
module PeopleSearch
  class Person < ApplicationRecord
    has_many :experiences, class_name: "PeopleSearch::PersonExperience", dependent: :delete_all
    has_many :education_experiences, class_name: "PeopleSearch::PersonEducationExperience", dependent: :delete_all
    has_many :notes, class_name: "PeopleSearch::Note", dependent: :delete_all

    has_many :attributes_people, class_name: "PeopleSearch::AttributePerson", dependent: :delete_all
    has_many :person_attributes, through: :attributes_people
  end
end
