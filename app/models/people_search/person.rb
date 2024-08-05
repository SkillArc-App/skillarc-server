# == Schema Information
#
# Table name: people_search_people
#
#  id             :uuid             not null, primary key
#  assigned_coach :string
#  certified_by   :string
#  date_of_birth  :date
#  email          :string
#  first_name     :string
#  last_name      :string
#  phone_number   :string
#  search_vector  :text             not null
#  user_id        :string
#
module PeopleSearch
  class Person < ApplicationRecord
    has_many :experiences, class_name: "PeopleSearch::PersonExperience", dependent: :delete_all
    has_many :education_experiences, class_name: "PeopleSearch::PersonEducationExperience", dependent: :delete_all
    has_many :notes, class_name: "PeopleSearch::Note", dependent: :delete_all
  end
end
