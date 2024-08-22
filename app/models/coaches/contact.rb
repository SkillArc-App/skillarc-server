# == Schema Information
#
# Table name: coaches_contacts
#
#  id                        :bigint           not null, primary key
#  contact_direction         :string           not null
#  contact_type              :string           not null
#  contacted_at              :datetime         not null
#  note                      :text             not null
#  coaches_person_context_id :uuid
#
# Indexes
#
#  index_coaches_contacts_on_coaches_person_context_id  (coaches_person_context_id)
#
# Foreign Keys
#
#  fk_rails_...  (coaches_person_context_id => coaches_person_contexts.id)
#
module Coaches
  class Contact < ApplicationRecord
    belongs_to :person_context, class_name: "Coaches::PersonContext", foreign_key: "coaches_person_context_id", inverse_of: :contacts
  end
end
