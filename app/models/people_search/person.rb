# == Schema Information
#
# Table name: people_search_people
#
#  id             :uuid             not null, primary key
#  assigned_coach :string
#  date_of_birth  :date
#  email          :string           not null
#  first_name     :string
#  last_name      :string
#  phone_number   :string
#  search_vector  :text             not null
#
module PeopleSearch
  class Person < ApplicationRecord
    has_many :experiences, class_name: "PeopleSearch::PersonExperience", dependent: :destroy
    has_many :education_experiences, class_name: "PeopleSearch::PersonEducationExperience", dependent: :destroy
  end
end
