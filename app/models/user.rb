# == Schema Information
#
# Table name: users
#
#  id             :text             not null, primary key
#  email          :text
#  email_verified :datetime
#  first_name     :text
#  image          :text
#  last_name      :text
#  phone_number   :text
#  sub            :string           not null
#  zip_code       :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  User_email_key      (email) UNIQUE
#  index_users_on_sub  (sub) UNIQUE
#
class User < ApplicationRecord
  has_one :recruiter, dependent: :destroy
  has_one :seeker, dependent: :destroy
  has_one :onboarding_session, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :training_provider_profiles, dependent: :destroy

  def employer_admin?
    user_roles.map(&:role).map(&:name).include?(Role::Types::EMPLOYER_ADMIN)
  end

  def training_provider_profile
    training_provider_profiles.order(created_at: :desc).first
  end
end
