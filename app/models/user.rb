class User < ApplicationRecord
  has_one :recruiter
  has_one :profile
  has_many :onboarding_sessions
  has_and_belongs_to_many :roles, join_table: :user_roles
  has_many :user_roles
  has_many :seeker_training_providers
  has_many :training_provider_profiles

  def onboarding_session
    onboarding_sessions.order(created_at: :desc).first
  end

  def training_provider_profile
    training_provider_profiles.order(created_at: :desc).first
  end

  def employer_admin?
    user_roles.map(&:role).map(&:name).include?(Role::Types::EMPLOYER_ADMIN)
  end
end
