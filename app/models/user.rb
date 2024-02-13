# == Schema Information
#
# Table name: users
#
#  id                    :text             not null, primary key
#  email                 :text
#  email_verified        :datetime
#  first_name            :text
#  image                 :text
#  last_name             :text
#  phone_number          :text
#  sub                   :string           not null
#  user_type             :enum             default("SEEKER"), not null
#  zip_code              :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  onboarding_session_id :text
#
# Indexes
#
#  User_email_key                  (email) UNIQUE
#  User_onboarding_session_id_key  (onboarding_session_id) UNIQUE
#  index_users_on_sub              (sub) UNIQUE
#
class User < ApplicationRecord
  has_one :recruiter, dependent: :destroy
  has_one :seeker, dependent: :destroy
  has_many :onboarding_sessions, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :seeker_training_providers, dependent: :destroy
  has_many :training_provider_profiles, dependent: :destroy

  def applied_jobs
    (seeker&.applicants || []).map(&:job)
  end

  def employer_admin?
    user_roles.map(&:role).map(&:name).include?(Role::Types::EMPLOYER_ADMIN)
  end

  def onboarding_session
    onboarding_sessions.order(created_at: :desc).first
  end

  def saved_jobs
    job_ids = Event
              .where(aggregate_id: id, event_type: [Event::EventTypes::JOB_SAVED, Event::EventTypes::JOB_UNSAVED])
              .map(&:message)
              .group_by { |e| e.data[:job_id] }
              .map do |job_id, events|
      last_event = events.max_by(&:occurred_at)

      job_id if last_event.event_type == Event::EventTypes::JOB_SAVED
    end

    Job.where(id: job_ids.compact.uniq)
  end

  def training_provider_profile
    training_provider_profiles.order(created_at: :desc).first
  end
end
