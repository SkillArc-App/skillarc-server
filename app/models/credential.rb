# == Schema Information
#
# Table name: credentials
#
#  id              :text             not null, primary key
#  description     :text
#  issued_date     :text
#  name            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :text
#  profile_id      :text             not null
#  seeker_id       :uuid
#
# Foreign Keys
#
#  Credential_organization_id_fkey  (organization_id => organizations.id) ON DELETE => nullify ON UPDATE => cascade
#  Credential_profile_id_fkey       (profile_id => profiles.id) ON DELETE => restrict ON UPDATE => cascade
#
class Credential < ApplicationRecord
end
