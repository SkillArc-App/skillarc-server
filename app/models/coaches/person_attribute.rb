# == Schema Information
#
# Table name: coaches_person_attributes
#
#  id                        :uuid             not null, primary key
#  attribute_value_ids       :uuid             not null, is an Array
#  machine_derived           :boolean          default(FALSE), not null
#  attribute_id              :uuid             not null
#  coaches_person_context_id :uuid
#
# Indexes
#
#  index_coaches_person_attributes_on_coaches_person_context_id  (coaches_person_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (coaches_person_context_id => coaches_person_contexts.id)
#
module Coaches
  class PersonAttribute < ApplicationRecord
    belongs_to :person_context, class_name: "Coaches::PersonContext", foreign_key: "coaches_person_context_id", inverse_of: :person_attributes
  end
end
