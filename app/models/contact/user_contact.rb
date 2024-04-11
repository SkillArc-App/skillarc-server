# == Schema Information
#
# Table name: contact_user_contacts
#
#  id                :bigint           not null, primary key
#  email             :string
#  phone_number      :string
#  preferred_contact :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  slack_id          :string
#  user_id           :text             not null
#
# Indexes
#
#  index_contact_user_contacts_on_user_id  (user_id)
#
module Contact
  class UserContact < ApplicationRecord
    self.table_name = "contact_user_contacts"

    validates :preferred_contact, inclusion: { in: Contact::ContactPreference::ALL }
  end
end
